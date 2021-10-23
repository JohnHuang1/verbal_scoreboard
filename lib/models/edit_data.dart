import 'package:hive/hive.dart';

part 'edit_data.g.dart';

@HiveType(typeId: 2)
class EditData extends HiveObject{
  @HiveField(0)
  final String edit;
  @HiveField(1)
  final DateTime time;

  EditData(this.edit, this.time);
}