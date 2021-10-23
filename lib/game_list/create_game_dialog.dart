import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/game_list/team_radio_buttons.dart';

class CreateGameDialog extends StatelessWidget {
  final TextEditingController textFieldController;
  final Function confirmCallback;
  final Function cancelCallback;
  final Function radioButtonCallback;

  CreateGameDialog(
      {this.textFieldController, this.confirmCallback, this.cancelCallback, this.radioButtonCallback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create a New Game: "),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: "Name"),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Text("How many teams?"),
          ),
          TeamRadioButtons(onChangedCallback: (NumOfTeams value) => radioButtonCallback(value))
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
