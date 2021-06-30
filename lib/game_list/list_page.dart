import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:verbal_scoreboard/game_list/game_list_item.dart';
import 'package:verbal_scoreboard/game_list/team_radio_buttons.dart';
import 'package:verbal_scoreboard/models/game_data.dart';
import 'package:verbal_scoreboard/models/team_data.dart';
import 'package:verbal_scoreboard/shared/routes.dart';

import '../boxes.dart';
import 'create_game_dialog.dart';
import 'delete_game_dialog.dart';

enum _DialogChoice { NewGame, DeleteConfirmation }

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  TextEditingController _newGameTextFieldController = TextEditingController();
  NumOfTeams _radioValue = NumOfTeams.two;
  Map<int, bool> expanded = {-1: false};

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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).canvasColor,
        focusColor: Theme.of(context).cardColor,
        child: Icon(Icons.add),
        onPressed: () {
          _displayDialog(context, _DialogChoice.NewGame);
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

  _onGameTap(BuildContext context, int id, int index, GameData data) async {
    final result = await Navigator.pushNamed(context, GamePageRoute,
        arguments: {'id': id});
    if (result is bool && result) {
      data.delete();
      listKey.currentState.removeItem(index, (_, __) => Container(),
          duration: const Duration(milliseconds: 500));
    }
  }

  Widget _buildList(List<GameData> gameList) {
    if (gameList.isEmpty) {
      return Center(
          child: Text("No Games to Show", style: TextStyle(fontSize: 24)));
    } else {
      return AnimatedList(
        key: listKey,
        physics: BouncingScrollPhysics(),
        initialItemCount: gameList.length,
        itemBuilder: (context, index, animation) => _itemBuilder(
            context, gameList.reversed.toList()[index], animation, index),
      );
    }
  }

  Widget _itemBuilder(
      BuildContext context, GameData data, Animation animation, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: Dismissible(
        child: GestureDetector(
          child: GameListItem(
            data,
            expanded: expanded.containsKey(data.key) ? true : false,
          ),
          onTap: () => _onGameTap(context, data.key, index, data),
          onLongPress: () {
            setState(() {
              if (expanded.containsKey(data.key))
                expanded = {};
              else
                expanded = {data.key: true};
            });
          },
        ),
        key: ValueKey(data.key),
        background: Container(
          color: Theme.of(context).backgroundColor,
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
          ]),
        ),
        confirmDismiss: (direction) async {
          bool result = await _displayDialog(
              context, _DialogChoice.DeleteConfirmation,
              selectedGame: data, index: index);
          return result;
        },
        direction: DismissDirection.endToStart,
        dismissThresholds: {DismissDirection.endToStart: 0.2},
      ),
    );
  }

  Future<dynamic> _displayDialog(BuildContext context, _DialogChoice choice,
      {GameData selectedGame, int index}) async {
    if (choice == _DialogChoice.DeleteConfirmation && selectedGame == null)
      return;
    return showDialog(
      context: context,
      builder: (context) {
        switch (choice) {
          case _DialogChoice.NewGame:
            return CreateGameDialog(
              textFieldController: _newGameTextFieldController,
              confirmCallback: () async {
                String name = _newGameTextFieldController.text;
                if (name != "" && _radioValue.toInt() != -1) {
                  await _addGame(_newGameTextFieldController.text, _radioValue);
                  if (listKey.currentState != null) {
                    listKey.currentState.insertItem(0,
                        duration: const Duration(milliseconds: 500));
                  }
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
          case _DialogChoice.DeleteConfirmation:
            return DeleteGameDialog(
              selectedGame,
              onConfirm: () async {
                await selectedGame.delete();
                listKey.currentState.removeItem(index, (_, __) => Container(),
                    duration: const Duration(milliseconds: 500));
              },
            );
          default:
            return Container();
        }
      },
    );
  }
}
