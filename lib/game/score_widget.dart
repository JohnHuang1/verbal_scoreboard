import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/game/edit_score_dialog.dart';
import 'package:verbal_scoreboard/game/team_settings_dialog.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

enum _DialogChoice { settings, score }

class ScoreWidget extends StatelessWidget {
  final GameData _game;
  final double teamNameHeight = 50;
  final double verticalButtonHeight = 70;
  final double cardPaddingVertical = 5;
  final double cardPaddingHorizontal = 5;
  final double buttonPadding = 5;
  final BoxConstraints constraints;

  TextEditingController scoreController;
  TextEditingController nameController;
  bool vertical = false;

  ScoreWidget(this._game, this.constraints, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    vertical = constraints.maxHeight >= constraints.maxWidth;
    height = constraints.maxHeight /
            2 *
            (!vertical ? (4 / _game.teams.length).round() : 1) -
        cardPaddingVertical * 2;
    width = constraints.maxWidth /
            2 *
            (vertical ? (4 / _game.teams.length).round() : 1) -
        cardPaddingHorizontal * 2;
    return SingleChildScrollView(
      scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
      child: Wrap(
        direction: vertical ? Axis.horizontal : Axis.vertical,
        alignment: WrapAlignment.center,
        children: List.generate(
            _game.teams.length,
            (index) => _scoreCard(context, index, _game.teams[index], width,
                height, _game.teams.length)),
      ),
    );
  }

  Widget _scoreCard(BuildContext context, int index, TeamData team,
      double width, double height, int teamAmount) {
    if (teamAmount == 3 && index == 2) {
      if (vertical) {
        width *= 2;
        width += cardPaddingHorizontal * 2;
      } else {
        height *= 2;
        height += cardPaddingVertical * 2;
      }
    }
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: cardPaddingVertical, horizontal: cardPaddingHorizontal),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 10.0,
          color: Color(team.color) ?? Theme.of(context).cardColor,
          child: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
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
                  onLongPress: () {
                    nameController =
                        TextEditingController(text: team.name.toString());
                    _displayDialog(
                        context, _DialogChoice.settings, team, index);
                  },
                  onDoubleTap: () {
                    scoreController =
                        TextEditingController(text: team.score.toString());
                    _displayDialog(context, _DialogChoice.score, team, index);
                  },
                ),
                if (vertical)
                  _getScore(context, team, index, width,
                      height - teamNameHeight - verticalButtonHeight)
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getScore(context, team, index, width / 2,
                          height - teamNameHeight),
                      Column(
                        children: _getControlButtonList(Theme.of(context),
                            index, width / 2, (height - teamNameHeight) / 2),
                      )
                    ],
                  ),
                if (vertical)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _getControlButtonList(
                        Theme.of(context), index, width, verticalButtonHeight),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getControlButtonList(
      ThemeData theme, int index, double width, double height) {
    height -= buttonPadding * 2;
    width -= buttonPadding * 2;
    return [
      _changeScoreButton(theme, index, width, height, Icons.add, () {
        _game.changeScore(index, 1);
      }),
      _changeScoreButton(theme, index, width, height, Icons.remove, () {
        _game.changeScore(index, -1);
      }),
    ];
  }

  Widget _getScore(BuildContext context, TeamData team, index, double width, double height) {
    return GestureDetector(child: Container(
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
      onLongPress: () {
        nameController =
            TextEditingController(text: team.name.toString());
        _displayDialog(context, _DialogChoice.settings, team, index);
      },
      onDoubleTap: () {
        scoreController =
            TextEditingController(text: team.score.toString());
        _displayDialog(context, _DialogChoice.score, team, index);
      },);
  }

  Widget _changeScoreButton(ThemeData theme, int index, double width,
      double height, IconData icon, Function onPressed) {
    return Container(
      height: height,
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
      margin: EdgeInsets.symmetric(
          vertical: buttonPadding, horizontal: buttonPadding),
    );
  }

  Future<dynamic> _displayDialog(
      BuildContext context, _DialogChoice choice, TeamData team, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        switch (choice) {
          case _DialogChoice.score:
            return EditScoreDialog(
              textFieldController: scoreController,
              confirmCallback: () {
                _game.changeScore(index, int.parse(scoreController.text),
                    originalValue: _game.teams[index].score);
              },
              teamData: team,
            );
          case _DialogChoice.settings:
            return TeamSettingsDialog(
              textFieldController: nameController,
              confirmCallback: (newColor) {
                _game.changeTeamName(index, nameController.text);
                _game.changeTeamColor(index, newColor.value);
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
