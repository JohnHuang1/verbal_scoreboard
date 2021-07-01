import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/models/edit_data.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import '../shared/style.dart';

class EditHistoryWidget extends StatefulWidget {
  final GameData _gameData;
  final bool expanded;
  final BoxConstraints constraints;
  final Function onCloseAction;

  const EditHistoryWidget(this._gameData,
      {Key key, @required this.expanded, this.constraints, this.onCloseAction})
      : super(key: key);

  @override
  _EditHistoryWidgetState createState() => _EditHistoryWidgetState();
}

class _EditHistoryWidgetState extends State<EditHistoryWidget>
    with SingleTickerProviderStateMixin {
  double sheetTopMargin = 5;
  double sheetListHeight = 400;
  double sheetHeaderHeight = 50;

  Duration duration = Duration(milliseconds: 500);

  AnimationController expandController;

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void didUpdateWidget(EditHistoryWidget oldWidget) {
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
    ThemeData theme = Theme.of(context);
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: expandController, curve: Curves.fastOutSlowIn)),
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Container(
              height: widget.constraints.maxHeight - sheetHeaderHeight,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child:
                  widget._gameData != null && widget._gameData.edits.isNotEmpty
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: widget._gameData.edits.length,
                          itemBuilder: (context, index) =>
                              _historyBuilder(widget._gameData.edits.reversed.toList()[index]))
                      : Center(child: Text("No Edit History")),
            ),
            GestureDetector(
              child: Material(
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          "Game History",
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Icon(widget.expanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (widget.onCloseAction != null) widget.onCloseAction();
                  },
                  highlightColor: theme.canvasColor.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                elevation: 16.0,
                color: theme.cardColor,
                shadowColor: theme.cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
              ),
              onPanUpdate: (details) {
                if (details.delta.dy > 0.8) {
                  if (widget.onCloseAction != null) widget.onCloseAction();
                }
              },
            )
          ],
        ));
  }

  Widget _historyBuilder(EditData data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(data.edit),
            ),
          ),
          Column(
            children: [
              Text(DateFormat.jms().format(data.time)),
              Text(DateFormat.yMd().format(data.time))
            ],
          )
        ],
      ),
    );
  }
}
