import 'package:verbal_scoreboard/models/game_data.dart';
import 'control_widget.dart';
import 'score_widget.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatelessWidget {
  final GameData _game;
  GameWidget(this._game);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScoreWidget(_game),
        ControlWidget(_game)
      ],
    );
  }
}
