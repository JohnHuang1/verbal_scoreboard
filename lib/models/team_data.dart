import 'package:hive/hive.dart';

part 'team_data.g.dart';

@HiveType(typeId: 1)
class TeamData extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  int score;

  TeamData(this.name, this.score);
}
