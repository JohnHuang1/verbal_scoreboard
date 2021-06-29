import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

class GameListItem extends StatefulWidget {
  final GameData _gameData;
  final bool expanded;
  int highestScore;

  GameListItem(this._gameData, {Key key, this.expanded = true})
      : super(key: key){
    highestScore = _gameData.teams.reduce((value, element) => value.score > element.score ? value : element).score;
  }

  @override
  _GameListItemState createState() => _GameListItemState();
}

class _GameListItemState extends State<GameListItem> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Theme.of(context).accentColor,
    //   width: double.infinity,
    //   child: Padding(
    //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(_gameData.name),
    //         Text(
    //             "Date Created: ${DateFormat.yMd().format(_gameData.dateCreated)}")
    //       ],
    //     ),
    //   ),
    // );
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: Card(
        elevation: widget.expanded ? 15.0 : 8.0,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 20),
                  child: Text(widget._gameData.name,
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 15),
                  child: Text(
                      DateFormat('MMMM d, yyyy')
                          .format(widget._gameData.dateCreated),
                      style: Theme.of(context).textTheme.subtitle2),
                ),
              ],
            ),
            if (widget.expanded)
              Container(
                height: 80,
                margin: EdgeInsets.only(bottom: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget._gameData.teams.length,
                  itemBuilder: (context, index) =>
                      _scoreBuilder(widget._gameData.teams[index]),
                )
              ),
          ],
        ),
      ),
    );
  }

  Widget _scoreBuilder(TeamData data) {
    return Container(
      width: 80,
      child: Card(
        color: data.score == widget.highestScore ? Theme.of(context).highlightColor : Theme.of(context).backgroundColor,
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
            Text(
              data.score.toString(),
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
