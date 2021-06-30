import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verbal_scoreboard/game_list/team_radio_buttons.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

class EditScoreDialog extends StatelessWidget {
  final TextEditingController textFieldController;
  final Function confirmCallback;
  final Function cancelCallback;
  final TeamData teamData;

  EditScoreDialog(
      {this.textFieldController,
      this.confirmCallback,
      this.cancelCallback,
      this.teamData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Score for ${teamData.name}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: "Score"),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          onPressed: () async {
            if(cancelCallback != null) await cancelCallback();
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
          onPressed: () async {
            if(confirmCallback != null) await confirmCallback();
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
