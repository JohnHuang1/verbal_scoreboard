import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/game_list/team_radio_buttons.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';
import 'package:verbal_scoreboard/shared/routes.dart';

import '../boxes.dart';
import 'create_game_dialog.dart';
import 'delete_game_dialog.dart';

enum DialogChoice { NewGame, DeleteConfirmation }

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController _newGameTextFieldController = TextEditingController();
  NumOfTeams _radioValue = NumOfTeams.two;

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
          _displayDialog(context, DialogChoice.NewGame);
        },
      ),
    );
  }

  Future _addGame(String name, NumOfTeams numOfTeams) async {
    final game = GameData()
      ..name = name
      ..dateCreated = DateTime.now()
      ..teams = List.generate(
          numOfTeams.toInt(), (index) => TeamData("Team ${(index + 1)}", 0))
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

    return Dismissible(
      child: GestureDetector(
        child: Container(
          color: Colors.lightBlue,
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name),
                  Text(
                      "Date Created: ${DateFormat.yMd().format(data.dateCreated)}")
                ],
              ),),
        ),
        onTap: () => _onGameTap(context, data.key),
      ),
      key: ValueKey(data.name),
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.delete_forever),
            ),
          ]
        ),
      ),
      confirmDismiss: (direction) async {
        bool result = await _displayDialog(context, DialogChoice.DeleteConfirmation,
            selectedGame: data);
        return result;
      },
      direction: DismissDirection.endToStart,
      dismissThresholds: {DismissDirection.endToStart : 0.2},
    );
  }

  Future<dynamic> _displayDialog(BuildContext context, DialogChoice choice,
      {GameData selectedGame}) async {
    if (choice == DialogChoice.DeleteConfirmation && selectedGame == null)
      return;
    return showDialog(
      context: context,
      builder: (context) {
        switch (choice) {
          case DialogChoice.NewGame:
            return CreateGameDialog(
              textFieldController: _newGameTextFieldController,
              confirmCallback: () async {
                String name = _newGameTextFieldController.text;
                if (name != "" && _radioValue.toInt() != -1) {
                  await _addGame(_newGameTextFieldController.text, _radioValue);
                }
                _newGameTextFieldController.clear();
              },
              cancelCallback: () {
                _newGameTextFieldController.clear();
              },
              radioButtonCallback: (NumOfTeams value) {
                _radioValue = value;
              },
            );
          case DialogChoice.DeleteConfirmation:
            return DeleteGameDialog(
              selectedGame,
              onConfirm: () {
                selectedGame.delete();
              },
            );
          default:
            return Container();
        }
      },
    );
  }
}
