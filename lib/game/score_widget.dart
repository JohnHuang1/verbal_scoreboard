import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

class ScoreWidget extends StatelessWidget {
  final double boxSize = 100;
  final GameData _game;
  final columns = 2;
  final rows = 2;
  final double runSpacing = 6;
  final double spacing = 8;
  final double margin = 5;
  final double teamNameHeight = 40;
  final double buttonHeight = 50;
  final double editHistoryHeaderHeight = 50;
  final BoxConstraints constraints;

  ScoreWidget(this._game, this.constraints, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final width = (constraints.maxWidth -
            (runSpacing + spacing) * (columns - 1) -
            (margin) * columns) /
        columns *
        (rows / (_game.teams.length / 2).round());
    final height = (constraints.maxHeight -
            (teamNameHeight + buttonHeight + margin * 2) * rows -
            editHistoryHeaderHeight - 40) /
        rows;
    // final unitHeightValue = constraints.maxHeight * 0.01;
    return SingleChildScrollView(
      child: Wrap(
        runAlignment: WrapAlignment.spaceAround,
        runSpacing: runSpacing,
        spacing: spacing,
        alignment: WrapAlignment.center,
        children: List.generate(
            _game.teams.length,
            (index) =>
                _scoreCard(context, index, _game.teams[index], width, height)),
      ),
    );
  }

  Widget _scoreCard(BuildContext context, int index, TeamData team,
      double width, double height) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      // padding: EdgeInsets.zero,
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 10.0,
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            Container(
              height: teamNameHeight,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  team.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              padding: EdgeInsets.only(top: 10),
            ),
            Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  team.score.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: width,
              height: height,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _changeScoreButton(Theme.of(context), index, width, Icons.add, (){
                  _addToTeam(index);
                }),
                _changeScoreButton(Theme.of(context), index, width, Icons.remove, (){
                  _subtractFromTeam(index);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addToTeam(int index, {int score}) {
    _game.teams[index].score += score ?? 1;
    _game.save();
  }

  _subtractFromTeam(int index, {int score}) {
    _game.teams[index].score -= score ?? 1;
    _game.save();
  }

  Widget _changeScoreButton(ThemeData theme, int index, double width, IconData icon, Function onPressed){
    return Container(
      height: buttonHeight,
      child: TextButton(
        onPressed: (){
          onPressed();
        },
        child: Icon(
          icon,
          color: theme.canvasColor,
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith((state) => theme.canvasColor.withOpacity(0.2)),
        ),
      ),
      width: width / 2 - 20,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius:
        BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    );
  }
}
