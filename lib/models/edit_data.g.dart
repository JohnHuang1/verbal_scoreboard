// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EditDataAdapter extends TypeAdapter<EditData> {
  @override
  final int typeId = 2;

  @override
  EditData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EditData(
      fields[0] as String,
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EditData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.edit)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
