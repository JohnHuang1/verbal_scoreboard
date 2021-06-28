import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/models/edit_data.dart';
import 'package:verbal_scoreboard/models/game_data.dart';

class EditHistoryWidget extends StatefulWidget {
  final GameData _gameData;

  const EditHistoryWidget(this._gameData, {Key key}) : super(key: key);

  @override
  _EditHistoryWidgetState createState() => _EditHistoryWidgetState();
}

class _EditHistoryWidgetState extends State<EditHistoryWidget> {
  bool _expanded = false;

  double sheetTopMargin = 5;
  double sheetListHeight = 400;
  double sheetHeaderHeight = 50;

  @override
  Widget build(BuildContext context) {

    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DraggableScrollableSheet(
            initialChildSize: (sheetHeaderHeight + sheetTopMargin) / constraints.maxHeight,
            minChildSize: (sheetHeaderHeight + sheetTopMargin) / constraints.maxHeight,
            // maxChildSize: (sheetHeaderHeight + sheetTopMargin + sheetListHeight) / constraints.maxHeight,
            builder: (context, scrollController) {
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return;
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  controller: scrollController,
                  child: Stack(
                    children: [
                      Container(
                        height: constraints.maxHeight - sheetHeaderHeight - sheetTopMargin,
                        margin: EdgeInsets.only(top: sheetHeaderHeight + sheetTopMargin),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                          Border(top: BorderSide(width: 2, color: Colors.grey)),
                        ),
                        child: widget._gameData.edits.isNotEmpty
                            ? ListView.builder(
                          controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            itemCount: widget._gameData.edits.length,
                            itemBuilder: (context, index) =>
                                _historyBuilder(widget._gameData.edits[index]))
                            : Center(child: Text("No Edit History")),
                      ),
                      Container(
                        height: sheetHeaderHeight,
                        margin: EdgeInsets.only(top: sheetTopMargin),
                        child: Row(
                          children: [
                            Spacer(),
                            Text("Score History"),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Icon(_expanded
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                          boxShadow: [BoxShadow(
                            blurRadius: 7,
                            offset: Offset(0, 7),
                            color: Colors.black38,
                          ),]
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
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
