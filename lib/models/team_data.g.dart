// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamDataAdapter extends TypeAdapter<TeamData> {
  @override
  final int typeId = 1;

  @override
  TeamData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamData(
      fields[0] as String,
      fields[1] as int,
      color: fields[2] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, TeamData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
