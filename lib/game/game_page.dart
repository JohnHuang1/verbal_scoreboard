import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/models/game_data.dart';

class GamePage extends StatelessWidget {
  final int _gameID;

  GamePage(this._gameID);

  @override
  Widget build(BuildContext context) {
    final data = GameData.fetchByID(_gameID);
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name + " | " + data.id.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Scores and stuff",
            ),
          )
        ],
      ),
    );
  }
}
