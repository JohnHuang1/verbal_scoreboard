import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/game/edit_history_widget.dart';
import 'package:verbal_scoreboard/game/game_widget.dart';
import 'package:verbal_scoreboard/models/edit_data.dart';
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
  final dynamic _gameKey;

  _GamePageState(this._gameKey);

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
    bool _isEditingText = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        actions: [
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              //edit game name
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              game.delete();
              Navigator.pop(context, true);

              //Delete
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GameWidget(game),
            Align(
              alignment: Alignment.bottomCenter,
              child: EditHistoryWidget(game),
            )
          ],
        ),
      ),
    );
  }
}
