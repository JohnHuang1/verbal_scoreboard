import 'package:verbal_scoreboard/shared/routes.dart';
import 'package:hive/hive.dart';
import 'models/game_data.dart';

class Boxes {
  static Box<GameData> getGameDataBox() =>
      Hive.box<GameData>(GameDataBoxString);
}
