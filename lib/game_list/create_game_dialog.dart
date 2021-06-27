import 'package:flutter/material.dart';

class CreateGameDialog extends StatefulWidget {
  final TextEditingController textFieldController;
  final Function confirmCallback;
  final Function cancelCallback;

  CreateGameDialog(
      {this.textFieldController, this.confirmCallback, this.cancelCallback});

  @override
  _CreateGameDialogState createState() => _CreateGameDialogState();
}

class _CreateGameDialogState extends State<CreateGameDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create a New Game: "),
      content: TextField(
        controller: widget.textFieldController,
        decoration: InputDecoration(hintText: "Name"),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          onPressed: () async {
            // setState(() {
            //   Navigator.pop(context);
            // });
            await widget.cancelCallback();
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
            await widget.confirmCallback();
            // setState(() {
            //   Navigator.pop(context);
            // });
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
