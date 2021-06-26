import 'package:verbal_scoreboard/models/team_data.dart';
import 'edit_data.dart';

class GameData {
  final int id;
  final String name;
  final DateTime dateCreated;
  final DateTime dateEdited;
  final List<TeamData> teams;
  final List<EditData> edits;

  GameData(
    this.id,
    this.name,
    this.dateCreated,
    this.dateEdited,
    this.teams,
    this.edits,
  );

  static List<GameData> fetchAll() {
    return [
      GameData(
          0,
          "Game1",
          DateTime.now(),
          DateTime.now(),
          [TeamData("Team11", 0), TeamData("Team12", 1)],
          [EditData("Added one point to Team12", DateTime.now())]),
      GameData(
          1,
          "Game2",
          DateTime.now(),
          DateTime.now(),
          [TeamData("Team21", 1), TeamData("Team22", 2)],
          [EditData("Added one point to Team22", DateTime.now())]),
    ];
  }

  static GameData fetchByID(int id) {
    List<GameData> data = fetchAll();
    for (GameData d in data) {
      if (d.id == id) {
        return d;
      }
    }
    return null;
  }
}
