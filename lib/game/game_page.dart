import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_event.dart';
import 'package:verbal_scoreboard/game/edit_history_widget.dart';
import 'package:verbal_scoreboard/game/jarvis_widget.dart';
import 'package:verbal_scoreboard/game/score_widget.dart';
import 'package:verbal_scoreboard/game_list/delete_game_dialog.dart';
import 'mic_widget.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:porcupine/porcupine_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:volume_control/volume_control.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:async/async.dart';

import '../boxes.dart';

class GamePage extends StatefulWidget {
  final dynamic _gameKey;

  GamePage(this._gameKey);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double vol;
  final FlutterTts flutterTts = FlutterTts();
  final Random random = new Random();

  TextEditingController _editingController;
  bool _isEditingText = false;
  bool historyExpanded = false;
  bool _jarvisOn = false;
  FocusNode nameFocusNode = FocusNode();
  PorcupineManager _porcupineManager;

  // stt.SpeechToText _speech;
  SpeechToTextProvider speechProvider;
  StreamSubscription<SpeechRecognitionEvent> _subscription;
  bool _isListening = false;
  int totalTeams = 0;
  GameData currentGame;
  bool sttAvailable = false;
  bool timerRunning = false;
  CancelableOperation timeoutTimer;

  String _initialText;

  @override
  void initState() {
    super.initState();
    loadVolume();
    speechInit();
    createPorcupineManager();
    speechProvider = SpeechToTextProvider(stt.SpeechToText());
    sttInit();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _porcupineManager.delete();
    // _speech.cancel();
    _subscription.cancel();
    print("test");
    print("speechProvider has listeners? : ${speechProvider.hasListeners}");
    speechProvider.removeListener(speechListener);
    print("speechProvider has listeners? : ${speechProvider.hasListeners}");
    _subscription.cancel();
    super.dispose();
  }

  void loadVolume() async {
    vol = await VolumeControl.volume;
  }

  void speechInit() async {
    await flutterTts.setVoice({"name": "en-gb-x-gbd-local", "locale": "en-GB"});
    await flutterTts.setSpeechRate(0.7);
  }

  Future<void> sttInit() async {
    bool available = await speechProvider.initialize();
    _subscription = speechProvider.stream.listen((recognitionEvent) {
      print("recognitionEvent.eventType = ${recognitionEvent.eventType}");
      if (recognitionEvent.eventType ==
          SpeechRecognitionEventType.finalRecognitionEvent) {
        print("I heard: ${recognitionEvent.recognitionResult.recognizedWords}");
        cancelNHTimer();
        stopListening(recognitionEvent.recognitionResult.recognizedWords);
      }
    }, onDone: () {
      print("subscription: OnDone called");
    }, onError: (val) {
      print("subscription: onError called val = $val");
    });
    setState(() {
      sttAvailable = available;
    });
  }

  void createPorcupineManager() async {
    try {
      _porcupineManager =
          await PorcupineManager.fromKeywords(["jarvis"], _wakeWordCallback);
    } on PvError catch (err) {
      // handle porcupine init error
    }
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<GameData>>(
        valueListenable: Boxes.getGameDataBox().listenable(),
        builder: (context, box, _) {
          final selectedGame = box.get(widget._gameKey);
          currentGame = selectedGame;
          return GestureDetector(
            onTap: () {
              FocusNode node = FocusManager.instance.primaryFocus;
              if (node != null && node == nameFocusNode) {
                _saveName(selectedGame);
              }
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: _buildContent(context, selectedGame),
          );
        });
  }

  Widget _buildContent(BuildContext context, GameData game) {
    _initialText = game?.name ?? "";
    _editingController = TextEditingController(text: _initialText);
    totalTeams = game.teams.length;
    final double iconButtonSplashRadius = 20;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: iconButtonSplashRadius,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: _editTitleTextField(_editingController, game),
        actions: [
          IconButton(
            splashRadius: iconButtonSplashRadius,
            icon: Icon(_jarvisOn ? Icons.mic_off : Icons.mic),
            onPressed: () async {
              setState(() {
                _jarvisOn = !_jarvisOn;
              });

              if (_jarvisOn == true) {
                try {
                  speak("Hello sir.");
                  await _porcupineManager.start();
                  // if (!sttAvailable) await sttInit();
                  speechProvider.addListener(speechListener);
                } on PvAudioException catch (ex) {
                  // deal with either audio exception
                }
              } else {
                speechProvider.removeListener(speechListener);
                speak("Shutting systems down.");
                await _porcupineManager.stop();
              }
            },
          ),
          IconButton(
            splashRadius: iconButtonSplashRadius,
            icon: Icon(Icons.history),
            onPressed: () {
              setState(() {
                historyExpanded = !historyExpanded;
              });
            },
          ),
          IconButton(
            splashRadius: iconButtonSplashRadius,
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool result = await showDialog(
                  builder: (context) {
                    return DeleteGameDialog(game);
                  },
                  context: context);
              if (result) Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.topCenter,
              children: game != null
                  ? [
                      ScoreWidget(game, constraints),
                      IgnorePointer(
                        child: Align(
                          alignment: Alignment.center,
                          child: JarvisWidget(
                              show: _jarvisOn,
                              hide: _isListening,
                              constraints: constraints),
                        ),
                      ),
                      IgnorePointer(
                        child: Align(
                          alignment: Alignment.center,
                          child: MicWidget(
                              show: _isListening, constraints: constraints),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: EditHistoryWidget(
                          game,
                          expanded: historyExpanded,
                          constraints: constraints,
                          onCloseAction: () {
                            setState(
                              () {
                                historyExpanded = false;
                              },
                            );
                          },
                        ),
                      ),
                    ]
                  : [
                      Container(
                        child: Text("Game Missing"),
                      ),
                    ],
            );
          },
        ),
      ),
    );
  }

  Widget _editTitleTextField(
      TextEditingController _editingController, GameData game) {
    if (_isEditingText)
      return Center(
        child: TextField(
          focusNode: nameFocusNode,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          onSubmitted: (newValue) {
            setState(() {
              _saveName(game);
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              setState(() {
                _isEditingText = true;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Text(_initialText, style: TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ],
    );
  }

  void _saveName(GameData game) {
    game.changeName(_editingController.text);
    _initialText = _editingController.text;
    _isEditingText = false;
  }

  void _wakeWordCallback(int keywordIndex) async {
    vol = await VolumeControl.volume;
    if (vol > .1) VolumeControl.setVolume(0.1);
    await Future.delayed(Duration(milliseconds: 200), () {});
    if (keywordIndex == 0) {
      if ((sttAvailable || speechProvider.isListening) &&
          speechProvider.isAvailable) _listen();
    }
  }

  void _listen() async {
    await _porcupineManager.stop();
    speechProvider.listen(
      listenFor: Duration(seconds: 10),
      pauseFor: Duration(seconds: 3),
      partialResults: false,
    );
    if (timerRunning) {
      cancelNHTimer();
    }
    timeoutTimer = nothingHappenedTimer();
    timeoutTimer.asStream().listen((event) {
      print("nothingHappenedTimer event called");
      if (_isListening) {
        print("timer finished - stopListening called");
        stopListening(null);
      }
      timerRunning = false;
    });
    setState(() {
      _isListening = true;
      print("ifAvailable: _isListening = $_isListening");
    });
  }

  // void _onStatus(String val) {
  //   if (val == stt.SpeechToText.notListeningStatus) {
  //     print("notListeningStatusCondition Reached");
  //     // setState(() {
  //     //   _isListening = false;
  //     //   print("onStatus: _isListening = $_isListening");
  //     // });
  //     _isListening = false;
  //     print("onStatus: _isListening = $_isListening");
  //   }
  //   print('onStatus: $val');
  // }
  //
  // void _onError(val) {
  //   print('onError: $val');
  //   // setState(() {
  //   //   _isListening = false;
  //   //   print("onError: _isListening = $_isListening");
  //   // });
  //   _isListening = false;
  //   print("onError: _isListening = $_isListening");
  //   stopListening(false);
  // }

  void stopListening(String parseString) async {
    setState(() {
      _isListening = false;
      print("stopListening: SetState called");
    });
    VolumeControl.setVolume(vol);
    if (parseString != null) {
      if (!await parseSpeech(parseString)) {
        _porcupineManager.start();
      }
    } else {
      _porcupineManager.start();
    }
  }

  CancelableOperation nothingHappenedTimer() {
    print("timer timerStarted");
    timerRunning = true;
    return CancelableOperation.fromFuture(
        Future.delayed(const Duration(seconds: 8), () {}), onCancel: () {
      print("timer canceled");
    });
  }

  void cancelNHTimer(){
    timerRunning = false;
    timeoutTimer.cancel();
  }

  void speechListener() {
    print("addListener: -----------------------");
    print(
        "addListener: speechProvider.isNotListening = ${speechProvider.isNotListening}");
    if (speechProvider.hasError && speechProvider.isNotListening) {
      print(
          "addListener: speechProvider.lastError = ${speechProvider.lastError}");
      stopListening(null);
      timeoutTimer.cancel();
    } else {
      print("addListener: has no error ");
    }
  }

  Future<bool> parseSpeech(parseString) async {
    print("parseSpeech: Command = $parseString");
    if (parseString.length > 0) {
      List words = parseString.split(" ").map((element) {
        return convStrToNum(element.toLowerCase());
      }).toList();
      print("parseSpeech: words = ${words.toString()}");
      if (words.length > 0) {
        if (words.contains("team") && words.last != "team") {
          // add/subtract 1 point
          print("add/subtract reached");
          try {
            int teamNum = int.tryParse(words[words.indexOf("team") + 1]) ??
                (throw Exception("Could not understand team number"));
            if (teamNum > 0 && teamNum <= totalTeams) {
              String speech = "one point ";
              if (words.contains("subtract")) {
                currentGame.changeScore(teamNum - 1, -1);
                speech += "taken from ";
              } else {
                currentGame.changeScore(teamNum - 1, 1);
                speech += "added to ";
              }
              print(speech + "team $teamNum");
              await speak(speech + "team $teamNum");
            } else {
              throw Exception("Team number not in range");
            }
          } on Exception catch (ex) {
            print(ex.toString().replaceAll("Exception: ", ""));
            await speak(ex.toString().replaceAll("exception", ""));
            return false;
          }
        } else if (words.contains("score")) {
          // read score
          print("readScore");
          String speech = "";
          currentGame.teams.forEach((element) {
            speech +=
                "${element.name} has ${element.score} point${element.score == 1 ? "" : "s"}. ";
          });
          print(speech);
          await speak(speech);
        } else if (words.contains("randomize")) {
          // Choose random team
          print("Choose random team");
          int teamNum = random.nextInt(totalTeams) + 1;
          await speak("team $teamNum has been chosen");
        } else if (words.contains("shut") && words.contains("down")) {
          // Shutdown jarvis
          if (words.length > words.indexOf("shut") + 1 &&
              words[words.indexOf("shut") + 1] == "down") {
            speechProvider.removeListener(speechListener);
            print("Shutdown jarvis 2");
            await speak("Shutting systems down");
            setState(() {
              _jarvisOn = false;
            });
            return true;
          }
        } else {
          // Catch all didn't understands
          print("Catch all didn't understands");
          await speak("What did you say sir?");
        }
      }
    }
    return false;
  }

  String convStrToNum(String str) {
    var nums = <String, String>{
      'one': '1',
      'two': '2',
      'three': '3',
      'four': '4',
      'five': '5',
      'six': '6',
      'seven': '7',
      'eight': '8',
      'nine': '9',
      'ten': '10',
    };
    if (nums.keys.contains(str)) {
      return nums[str];
    }
    return str;
  }
}
