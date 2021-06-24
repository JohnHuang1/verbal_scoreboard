import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';
import 'package:verbal_scoreboard/shared/routes.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController _newGameTextFieldController = TextEditingController();
  List<GameData> games = GameData.fetchAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Page"),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) => _itemBuilder(context, games[index]),
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
      onTap: () => _onGameTap(context, data.id),
    );
  }

  _onGameTap(BuildContext context, int id) {
    Navigator.pushNamed(context, GamePageRoute, arguments: {'id': id});
  }

  Future<void> _displayNewGameDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create a New Game: "),
          content: TextField(
            controller: _newGameTextFieldController,
            decoration: InputDecoration(hintText: "Name"),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              onPressed: () {
                setState(() {
                  games.add(GameData(
                      2,
                      _newGameTextFieldController.text,
                      DateTime.now(),
                      null,
                      [TeamData("t1", 0), TeamData("t1", 0)],
                      []));
                  Navigator.pop(context);
                });
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
