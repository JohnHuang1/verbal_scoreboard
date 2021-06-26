import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/models/game_data.dart';


class ControlWidget extends StatelessWidget {
  final GameData _game;
  ControlWidget(this._game, {Key key}) : super(key: key);

  _addToTeam(int index, {int score}){
    _game.teams[index].score += score ?? 1;
    _game.save();
  }
  _subtractFromTeam(int index, {int score}){
    _game.teams[index].score -= score ?? 1;
    _game.save();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              _addToTeam(0);
            },
            child: Icon(Icons.add)),
        TextButton(
            onPressed: () {
              _subtractFromTeam(0);
            },
            child: Icon(Icons.remove)),
        TextButton(onPressed: () {}, child: Icon(Icons.mic)),
        TextButton(
            onPressed: () {
              _addToTeam(1);
            },
            child: Icon(Icons.add)),
        TextButton(
            onPressed: () {
              _subtractFromTeam(1);
            },
            child: Icon(Icons.remove))
      ],
    );
  }

}

