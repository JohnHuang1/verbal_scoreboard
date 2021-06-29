import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

class ScoreWidget extends StatelessWidget {
  final double boxSize = 100;
  final GameData _game;
  ScoreWidget(this._game, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _game != null ? ListView.builder(
      itemCount: _game.teams.length,
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          _itemBuilder(context, _game.teams[index]),
    ) : Container(child: Text("No teams to show."));
  }

  Widget _itemBuilder(BuildContext context, TeamData team) {
    return Row(
      children: [
        Column(
          children: [
            Center(
              child: Text(team.name),
            ),
            Container(
              child: Center(
                  child: Text(team.score.toString(),
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
      ],
    );
  }
}
