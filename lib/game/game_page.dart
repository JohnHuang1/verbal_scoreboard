import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/game/edit_history_widget.dart';
import 'package:verbal_scoreboard/game/game_widget.dart';
import 'package:verbal_scoreboard/models/edit_data.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../boxes.dart';

class GamePage extends StatefulWidget {
  final dynamic _gameKey;

  GamePage(this._gameKey);

  @override
  _GamePageState createState() => _GamePageState(this._gameKey);
}

class _GamePageState extends State<GamePage> {
  TextEditingController _editingController;
  final dynamic _gameKey;

  _GamePageState(this._gameKey);
  String _initialText;
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<GameData>>(
        valueListenable: Boxes.getGameDataBox().listenable(),
        builder: (context, box, _) {
          final selectedGame = box.get(_gameKey);
          return _buildContent(context, selectedGame);
        });
  }

  Widget _buildContent(BuildContext context, GameData game) {
    bool _isEditingText = false;
    _initialText = 'hey';
    _editingController = TextEditingController(text: _initialText);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _initialText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
        /*_editTitleTextField(
            _isEditingText, _initialText, _editingController, game), */
        actions: [
          /*IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              //edit game name
            },
          ),
          */
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GameWidget(game),
            Align(
              alignment: Alignment.bottomCenter,
              child: EditHistoryWidget(game),
            )
          ],
        ),
      ),
    );
  }

  Widget _editTitleTextField(bool _isEditingText, String iText,
      TextEditingController _editingController, GameData game) {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              _initialText = newValue;
              game.name = newValue;
              game.save();
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return GestureDetector(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          _initialText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
