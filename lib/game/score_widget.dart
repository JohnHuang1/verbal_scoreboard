import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/game/edit_score_dialog.dart';
import 'package:verbal_scoreboard/game/team_settings_dialog.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

enum _DialogChoice { settings, score }

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

  TextEditingController scoreController;
  TextEditingController nameController;

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
            editHistoryHeaderHeight -
            40) /
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
        color: Color(team.color) ?? Theme.of(context).cardColor,
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
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
                  )
                ],
              ),
              onLongPress: () {
                nameController =
                    TextEditingController(text: team.name.toString());
                _displayDialog(context, _DialogChoice.settings, team, index);
              },
              onDoubleTap: () {
                scoreController =
                    TextEditingController(text: team.score.toString());
                _displayDialog(context, _DialogChoice.score, team, index);
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _changeScoreButton(Theme.of(context), index, width, Icons.add,
                    () {
                  _addToTeam(index);
                }),
                _changeScoreButton(
                    Theme.of(context), index, width, Icons.remove, () {
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

  Widget _changeScoreButton(ThemeData theme, int index, double width,
      IconData icon, Function onPressed) {
    return Container(
      height: buttonHeight,
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Icon(
          icon,
          color: theme.canvasColor,
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith(
              (state) => theme.canvasColor.withOpacity(0.2)),
        ),
      ),
      width: width / 2 - 20,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    );
  }

  Future<dynamic> _displayDialog(
      BuildContext context, _DialogChoice choice, TeamData team, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        switch(choice){
          case _DialogChoice.score:
            return EditScoreDialog(
              textFieldController: scoreController,
              confirmCallback: () {
                _game.teams[index].score = int.parse(scoreController.text);
                _game.save();
              },
              teamData: team,
            );
          case _DialogChoice.settings:
            return TeamSettingsDialog(
              textFieldController: nameController,
              confirmCallback: (newColor){
                _game.teams[index].name = nameController.text;
                _game.teams[index].color = newColor.value;
                _game.save();
              },
              teamData: team,
            );
          default:
            return Container();
        }
      },
    );
  }
}
