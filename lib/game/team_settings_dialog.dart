import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verbal_scoreboard/game/circle_color_picker.dart';
import 'package:verbal_scoreboard/models/team_data.dart';

class TeamSettingsDialog extends StatelessWidget {
  final TextEditingController textFieldController;
  final Function(Color) confirmCallback;
  final Function cancelCallback;
  final TeamData teamData;

  TeamSettingsDialog(
      {this.textFieldController,
        this.confirmCallback,
        this.cancelCallback,
        this.teamData});

  @override
  Widget build(BuildContext context) {
    Color chosenColor = Color(teamData.color) ?? Theme.of(context).cardColor;
    return AlertDialog(
      title: Text("Team Settings ${teamData.name}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: "Name"),
            textAlign: TextAlign.center,
            maxLength: 20,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Pick Team Color:")
          ),
          CircleColorPicker(initialColor: chosenColor, colorListener: (value){
            chosenColor = Color(value);
          },)
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
            if(confirmCallback != null) await confirmCallback(chosenColor);
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
