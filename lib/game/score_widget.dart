import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/models/game_data.dart';

class ScoreWidget extends StatelessWidget {
  final double boxSize = 100;
  final GameData _game;
  ScoreWidget(this._game, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Center(
              child: Text(_game.teams[0].name),
            ),
            Container(
              child: Center(
                  child: Text(_game.teams[0].score.toString(),
                      style: TextStyle(fontSize: 50))),
              height: boxSize,
              width: boxSize,
              color: Colors.red,
            )
          ],
        ),
        Column(children: [
          Text(""),
          Container(
            child: Text(
              "-",
              style: TextStyle(fontSize: 50),
            ),
          ),
        ]),
        Column(
          children: [
            Center(
              child: Text(_game.teams[1].name),
            ),
            Container(
              child: Center(
                  child: Text(_game.teams[1].score.toString(),
                      style: TextStyle(fontSize: 50))),
              height: boxSize,
              width: boxSize,
              color: Colors.lightBlue,
            )
          ],
        ),
      ],
    );
  }
}

