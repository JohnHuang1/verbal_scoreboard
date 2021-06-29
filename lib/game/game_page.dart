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
    return Scaffold(
      appBar: AppBar(
        title: Text("Game " +
            game.name +
            " | " +
            "ID: " +
            game.key.toString() +
            " | " +
            "Teams: " +
            game.teams.length.toString()),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              game.edits
                  .add(EditData("Added 1 point to Team 1", DateTime.now()));
              game.save();
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              game.edits.add(
                  EditData("Subtracted 1 point from Team 1", DateTime.now()));
              game.save();
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
