import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

class ScoreWidget extends StatefulWidget {
  final List<TeamData> teams;
  Function callback;
  ScoreWidget({Key key, this.teams, this.callback}) : super(key: key);

  @override
  _ScoreWidgetState createState() => _ScoreWidgetState(teams);

  refresh(List<TeamData> teams) {
    _ScoreWidgetState(teams).callback(teams);
  }
}

class _ScoreWidgetState extends State<ScoreWidget> {
  List<TeamData> teams;

  void callback(List<TeamData> teams) {
    setState(() {
      this.teams = teams;
    });
  }

  _ScoreWidgetState(this.teams);
  final double boxSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Center(
              child: Text(teams[0].name),
            ),
            Container(
              child: Center(
                  child: Text(teams[0].score.toString(),
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
              child: Text(teams[1].name),
            ),
            Container(
              child: Center(
                  child: Text(teams[1].score.toString(),
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
