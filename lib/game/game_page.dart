import 'package:flutter/material.dart';
import 'package:verbal_scoreboard/game/game_widget.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../boxes.dart';

class GamePage extends StatefulWidget {
  final dynamic _gameKey;

  GamePage(this._gameKey);

  @override
  _GamePageState createState() => _GamePageState(this._gameKey);
}

class _GamePageState extends State<GamePage>{
  final dynamic _gameKey;

  _GamePageState(this._gameKey);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<GameData>>(valueListenable: Boxes.getGameDataBox().listenable(), builder: (context, box, _) {
      final selectedGame = box.get(_gameKey);
      return _buildContent(context, selectedGame);
    });
  }

  Widget _buildContent(BuildContext context, GameData game){
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name + " | " + game.key.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [GameWidget(game)],
      ),
    );
  }

}
