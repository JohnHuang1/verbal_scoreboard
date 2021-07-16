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

import '../boxes.dart';

class GamePage extends StatefulWidget {
  final dynamic _gameKey;

  GamePage(this._gameKey);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  TextEditingController _editingController;
  bool _isEditingText = false;
  bool historyExpanded = false;
  bool _jarvisOn = false;
  FocusNode nameFocusNode = FocusNode();
  PorcupineManager _porcupineManager;
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "";

  String _initialText;

  @override
  void initState() {
    super.initState();
    createPorcupineManager();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _porcupineManager.delete();
    super.dispose();
  }

  void createPorcupineManager() async {
    try {
      _porcupineManager =
          await PorcupineManager.fromKeywords(["jarvis"], _wakeWordCallback);
    } on PvError catch (err) {
      // handle porcupine init error
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<GameData>>(
        valueListenable: Boxes.getGameDataBox().listenable(),
        builder: (context, box, _) {
          final selectedGame = box.get(widget._gameKey);
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
                  await _porcupineManager.start();
                } on PvAudioException catch (ex) {
                  // deal with either audio exception
                }
              } else {
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

  void _wakeWordCallback(int keywordIndex) {
    if (keywordIndex == 0) {
      _listen();
    }
  }

  void _listen() async {
    await _porcupineManager.stop();
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if(val == stt.SpeechToText.notListeningStatus){
            print("notListeningStatusCondition Reached");
            stopListening();
          }
          print('onStatus: $val');
        },
        onError: (val) {
          _command = "";
          stopListening();
          print('onError: $val');
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            _command = val.recognizedWords;
          },
        );
      }
    } else {
      _command = "";
      stopListening();
    }
  }

  void stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();
    parseSpeech();
    await _porcupineManager.start();
  }

  void parseSpeech(){
    if(_command.length > 0){
      List words = _command.split(" ").map((element) {
        return convStrToNum(element.toLowerCase());
      }).toList();
      if(words.length > 0){
        if(words.contains("team")){
          try{
            int teamNum = int.parse(words[words.indexOf("team") + 1]);
            //TODO: add one point to which ever team is said.
          } catch (ex){

          }
        }
      }
    }
  }

  String convStrToNum(String str) {
    var nums = <String, String> {
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
