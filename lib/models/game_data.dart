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

}


