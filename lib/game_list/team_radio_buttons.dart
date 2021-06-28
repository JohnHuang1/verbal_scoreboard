import 'package:flutter/material.dart';

enum NumOfTeams { two, three, four }

extension ParseToInt on NumOfTeams {
  int toInt() {
    switch (this) {
      case NumOfTeams.two:
        return 2;
      case NumOfTeams.three:
        return 3;
      case NumOfTeams.four:
        return 4;
      default:
        return -1;
    }
  }
}

class TeamRadioButtons extends StatefulWidget {
  final Function onChangedCallback;

  TeamRadioButtons({Key key, this.onChangedCallback}) : super(key: key);

  @override
  _TeamRadioButtonsState createState() => _TeamRadioButtonsState();
}

class _TeamRadioButtonsState extends State<TeamRadioButtons> {
  NumOfTeams _value = NumOfTeams.two;
  double titleGap = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListTile(
            title: Text('2'),
            leading: Radio(
              value: NumOfTeams.two,
              groupValue: _value,
              onChanged: (NumOfTeams value) {
                setState(() {
                  _value = value;
                  widget.onChangedCallback(_value);
                });
              },
            ),
            horizontalTitleGap: titleGap,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text('3'),
            leading: Radio(
              value: NumOfTeams.three,
              groupValue: _value,
              onChanged: (NumOfTeams value) {
                setState(() {
                  _value = value;
                  widget.onChangedCallback(_value);
                });
              },
            ),
            horizontalTitleGap: titleGap,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text('4'),
            leading: Radio(
              value: NumOfTeams.four,
              groupValue: _value,
              onChanged: (NumOfTeams value) {
                setState(() {
                  _value = value;
                  widget.onChangedCallback(_value);
                });
              },
            ),
            horizontalTitleGap: titleGap,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          ),
        ),
      ],
    );
  }
}
