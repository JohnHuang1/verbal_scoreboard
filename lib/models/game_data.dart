import 'dart:ui';

import 'package:verbal_scoreboard/models/team_data.dart';
import 'edit_data.dart';
import 'package:hive/hive.dart';

part 'game_data.g.dart';

@HiveType(typeId: 0)
class GameData extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime dateCreated;
  @HiveField(2)
  List<TeamData> teams;
  @HiveField(3)
  List<EditData> edits;

  GameData({
    this.name,
    this.dateCreated,
    this.teams,
    this.edits,
  });

  changeScore(int teamIndex, int scoreChange, {int originalValue}){
    if(originalValue != null){
      teams[teamIndex].score = scoreChange;
      _addEdit(teamIndex, "Score Change: $originalValue => $scoreChange");
    } else {
      teams[teamIndex].score += scoreChange;
      _addEdit(teamIndex, "Score Change: ${scoreChange >= 0 ? "+$scoreChange" : "$scoreChange"} points");
    }
    save();
  }

  changeTeamName(int teamIndex, String newName){
    String oldName = teams[teamIndex].name;
    if(oldName != newName){
      _addEdit(teamIndex, "Name Change: $oldName => $newName");
      teams[teamIndex].name = newName;
      save();
    }
  }

  changeTeamColor(int teamIndex, int newColor){
    int oldColor = teams[teamIndex].color;
    if(oldColor != newColor){
      _addEdit(teamIndex, "Color Change: ${Color(oldColor).toString()} => ${Color(newColor).toString()}");
      teams[teamIndex].color = newColor;
      save();
    }
  }

  changeName(String newName){
    if(name != newName) {
      edits.add(EditData("Game Name Change: $name => $newName", DateTime.now()));
      name = newName;
      save();
    }
  }

  _addEdit(int teamIndex, String edit){
    edits.add(EditData("Team: ${teams[teamIndex].name} " + edit, DateTime.now()));
  }

}


