import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/game/edit_history_widget.dart';
import 'package:verbal_scoreboard/game/game_widget.dart';
import 'package:verbal_scoreboard/game/score_widget.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../boxes.dart';

class GamePage extends StatefulWidget {
  final dynamic _gameKey;

  GamePage(this._gameKey);

  @override
  _GamePageState createState() => _GamePageState(this._gameKey);
}

class _GamePageState extends State<GamePage> {
  TextEditingController _editingController;
  final dynamic _gameKey;
  bool _isEditingText = false;

  _GamePageState(this._gameKey);
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
          final selectedGame = box.get(_gameKey);
          return _buildContent(context, selectedGame);
        });
  }

  Widget _buildContent(BuildContext context, GameData game) {
    _initialText = game.name;
    _editingController = TextEditingController(text: _initialText);
    return Scaffold(
      appBar: AppBar(
        title: _editTitleTextField(_editingController, game),
        actions: [
          /*IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              //edit game name
            },
          ),
          */
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, true);
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
              children: [
                ScoreWidget(game, constraints),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: EditHistoryWidget(game),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _editTitleTextField(TextEditingController _editingController, GameData game) {
    if (_isEditingText)
      return Center(
        child: TextField(
          style: TextStyle(color: Colors.white),
          onSubmitted: (newValue) {
            setState(() {
              _initialText = newValue;
              game.name = newValue;
              game.save();
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          _initialText,
        ));
  }
}
