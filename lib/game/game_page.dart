import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verbal_scoreboard/game/edit_history_widget.dart';
import 'package:verbal_scoreboard/game/score_widget.dart';
import 'package:verbal_scoreboard/game_list/delete_game_dialog.dart';
import 'package:verbal_scoreboard/game_list/mic_widget.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  bool _micOn = false;
  FocusNode nameFocusNode = FocusNode();

  String _initialText;

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
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
            icon: Icon(_micOn ? Icons.mic : Icons.mic_off),
            onPressed: () {
              setState(() {
                _micOn = !_micOn;
              });
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
                          child:
                          MicWidget(show: _micOn, constraints: constraints),
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
}
