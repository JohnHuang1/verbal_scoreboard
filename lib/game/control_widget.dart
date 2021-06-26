import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

import 'score_widget.dart';

class ControlWidget extends StatefulWidget {
  final List<TeamData> teams;
  ControlWidget({Key key, this.teams}) : super(key: key);

  @override
  _ControlWidgetState createState() => _ControlWidgetState(teams);
}

class _ControlWidgetState extends State<ControlWidget> {
  final List<TeamData> teams;

  _ControlWidgetState(this.teams);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              teams[0].score++;
              ScoreWidget(teams: teams);
            },
            child: Icon(Icons.add)),
        TextButton(
            onPressed: () {
              teams[0].score--;
              ScoreWidget().refresh(teams);
            },
            child: Icon(Icons.remove)),
        TextButton(onPressed: () {}, child: Icon(Icons.mic)),
        TextButton(
            onPressed: () {
              teams[1].score++;
              ScoreWidget(teams: teams);
            },
            child: Icon(Icons.add)),
        TextButton(
            onPressed: () {
              teams[1].score--;
              ScoreWidget(teams: teams);
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}
