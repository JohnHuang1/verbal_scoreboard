import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

class GameListItem extends StatefulWidget {
  final GameData _gameData;
  final bool expanded;
  int highestScore;
  String highestTeam;

  GameListItem(this._gameData, {Key key, this.expanded = true})
      : super(key: key) {
    highestScore = _gameData.teams
        .reduce(
            (value, element) => value.score > element.score ? value : element)
        .score;
    final list =
        _gameData.teams.where((element) => element.score == highestScore);
    highestTeam = list.length > 1 ? "Tie" : list.toList()[0].name;
  }

  @override
  _GameListItemState createState() => _GameListItemState();
}

class _GameListItemState extends State<GameListItem>
    with SingleTickerProviderStateMixin {
  Duration duration = Duration(milliseconds: 500);

  AnimationController expandController;

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void didUpdateWidget(GameListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.fastOutSlowIn,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
        child: Card(
          elevation: widget.expanded ? 20.0 : 8.0,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 20),
                    child: Text(widget._gameData.name,
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(widget.highestTeam)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 15),
                    child: Text(
                        DateFormat('MMMM d, yyyy')
                            .format(widget._gameData.dateCreated),
                        style: Theme.of(context).textTheme.subtitle2),
                  ),
                ],
              ),
              SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: expandController,
                  curve: Curves.fastOutSlowIn,
                ))
                  ..addListener(() {
                    setState(() {});
                  }),
                child: Container(
                  alignment: Alignment.center,
                  height: 80,
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget._gameData.teams.length,
                    itemBuilder: (context, index) =>
                        _scoreBuilder(widget._gameData.teams[index]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreBuilder(TeamData data) {
    return Container(
      width: 80,
      child: Card(
        color: data.score == widget.highestScore
            ? Theme.of(context).highlightColor
            : Theme.of(context).backgroundColor,
        elevation: 6.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Text(
                data.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Text(
                data.score.toString(),
                style: TextStyle(fontSize: 30),
                overflow: TextOverflow.fade,
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
