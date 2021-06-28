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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Row(
            children: [
              Spacer(),
              Text("Edit History"),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: GestureDetector(
                        child: Icon(_expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                        onTap: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        }),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        if (_expanded)
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(width: 2, color: Colors.grey)),
            ),
            child: widget._gameData.edits.isNotEmpty
                ? ListView.builder(
                    itemCount: widget._gameData.edits.length,
                    itemBuilder: (context, index) =>
                        _historyBuilder(widget._gameData.edits[index]))
                : Center(child: Text("No Edit History")),
          ),
      ],
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
