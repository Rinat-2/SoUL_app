// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
      fields[5] as int,
      fields[6] as double,
      fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.red)
      ..writeByte(4)
      ..write(obj.green)
      ..writeByte(5)
      ..write(obj.blue)
      ..writeByte(6)
      ..write(obj.opacity)
      ..writeByte(7)
      ..write(obj.lastNoteCorrectmillisecondsSinceEpoch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
