import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/models/game_data.dart';

class DeleteGameDialog extends StatelessWidget{
  final GameData _gameData;
  final Function onConfirm;
  final Function onCancel;
  const DeleteGameDialog(this._gameData, {Key key, this.onConfirm, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete this game FOREVER?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Name: ${_gameData.name}"),
          Text("Date Created: ${DateFormat.yMd().format(_gameData.dateCreated)}")
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          onPressed: () async {
            if(onCancel != null) await onCancel();
            Navigator.pop(context, false);
          },
          child: Text(
            "NO",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
          onPressed: () async {
            if(onConfirm != null) await onConfirm();
            Navigator.pop(context, true);
          },
          child: Text(
            "YES",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}