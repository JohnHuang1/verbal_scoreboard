import 'package:verbal_scoreboard/models/game_data.dart';
import 'control_widget.dart';
import 'score_widget.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatelessWidget {
  final GameData data;
  GameWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScoreWidget(teams: data.teams),
        ControlWidget(teams: data.teams)
      ],
    );
  }
}
