import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:verbal_scoreboard/shared/style.dart';

part 'team_data.g.dart';

@HiveType(typeId: 1)
class TeamData extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  int score;
  @HiveField(3)
  int color;

  TeamData(this.name, this.score, {this.color}){
    if(this.color == null) this.color = YellowColor.value;
  }
}
