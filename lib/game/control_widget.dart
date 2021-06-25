import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlWidget extends StatefulWidget {
  ControlWidget({Key key}) : super(key: key);

  @override
  _ControlWidgetState createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(onPressed: () {}, child: Icon(Icons.add)),
        TextButton(onPressed: () {}, child: Icon(Icons.remove)),
        TextButton(onPressed: () {}, child: Icon(Icons.mic)),
        TextButton(onPressed: () {}, child: Icon(Icons.add)),
        TextButton(onPressed: () {}, child: Icon(Icons.remove))
      ],
    );
  }
}
