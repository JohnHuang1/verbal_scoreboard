import 'dart:math';

import 'package:flutter/material.dart';
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
import 'package:flutter_tts/flutter_tts.dart';

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
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "";
  int totalTeams = 0;
  GameData currentGame;

  String _initialText;

  @override
  void initState() {
    super.initState();
    loadVolume();
    speechInit();
    createPorcupineManager();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _porcupineManager.delete();
    super.dispose();
  }

  void loadVolume() async {
    vol = await VolumeControl.volume;
  }

  void speechInit() async {
    // await flutterTts.setLanguage("en-GB");
    await flutterTts.setVoice({"name": "en-gb-x-gbd-local", "locale": "en-GB"});
    await flutterTts.setSpeechRate(0.7);
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
                } on PvAudioException catch (ex) {
                  // deal with either audio exception
                }
              } else {
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
    if(vol > .1) VolumeControl.setVolume(0.1);
    await Future.delayed(Duration(milliseconds: 200), (){});
    if (keywordIndex == 0) {
      _listen();
    }
  }

  void _listen() async {
    await _porcupineManager.stop();
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == stt.SpeechToText.notListeningStatus) {
            print("notListeningStatusCondition Reached");
            _isListening = false;
          }
          print('onStatus: $val');
        },
        onError: (val) {
          _isListening = false;
          print('onError: $val');
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            _command = val.recognizedWords;
            print("onResult = $_command");
            if(!_isListening) stopListening();
          },
        );
      }
    } else {
      stopListening();
    }
  }

  void stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();
    VolumeControl.setVolume(vol);
    if(!await parseSpeech()) {
      _porcupineManager.start();
    }
    _command = "";
  }

  Future<bool> parseSpeech() async {
    print("parseSpeech: Command = $_command");
    if (_command.length > 0) {
      List words = _command.split(" ").map((element) {
        return convStrToNum(element.toLowerCase());
      }).toList();
      print("parseSpeech: words = ${words.toString()}");
      if (words.length > 0) {
        if (words.contains("team")) {
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
          } catch (ex) {
            print((ex as Exception).toString());
            await speak((ex as Exception).toString());
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
        } else if (words.contains("end")) {
          //TODO: Do we really need this?
          // if (words[words.indexOf("end") + 1] == "game") {}
        } else if(words.contains("shut")){
          // Shutdown jarvis
          print("Shutdown jarvis");
          if(words[words.indexOf("shut") + 1] == "down"){
            print("Shutdown jarvis 2");
            await speak("Shutting systems down");
            setState(() {
              _jarvisOn = false;
            });
            return true;
          }
        }
        else {
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
