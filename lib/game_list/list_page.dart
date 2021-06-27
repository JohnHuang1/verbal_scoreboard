import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';
import 'package:verbal_scoreboard/shared/routes.dart';

import '../boxes.dart';
import 'create_game_dialog.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController _newGameTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("List Page"),
        ),
      ),
      body: ValueListenableBuilder<Box<GameData>>(
        valueListenable: Boxes.getGameDataBox().listenable(),
        builder: (context, box, _) {
          final gameDataList = box.values.toList().cast<GameData>();

          return _buildList(gameDataList);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          _displayNewGameDialog(context);
        },
      ),
    );
  }

  Future _addGame(String name) async {
    final game = GameData()
      ..name = name
      ..dateCreated = DateTime.now()
      ..teams = [TeamData("Team 1", 0), TeamData("Team 2", 0)]
      ..edits = [];

    final box = Boxes.getGameDataBox();
    box.add(game);
  }

  _onGameTap(BuildContext context, int id) {
    Navigator.pushNamed(context, GamePageRoute, arguments: {'id': id});
  }

  Widget _buildList(List<GameData> gameList) {
    if (gameList.isEmpty) {
      return Center(
          child: Text("No Games to Show", style: TextStyle(fontSize: 24)));
    } else {
      return ListView.builder(
        itemCount: gameList.length,
        itemBuilder: (context, index) => _itemBuilder(context, gameList[index]),
      );
    }
  }

  Widget _itemBuilder(BuildContext context, GameData data) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          color: Colors.lightBlue,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name),
                  Text(
                      "Date Created: ${DateFormat.yMd().format(data.dateCreated)}")
                ],
              )),
        ),
      ),
      onTap: () => _onGameTap(context, data.key),
    );
  }

  Future<void> _displayNewGameDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return CreateGameDialog(
          textFieldController: _newGameTextFieldController,
          confirmCallback: () async {
            await _addGame(_newGameTextFieldController.text);
            _newGameTextFieldController.clear();
          },
          cancelCallback: () {
            _newGameTextFieldController.clear();
          },
        );
      },
    );
  }
}
