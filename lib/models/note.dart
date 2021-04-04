import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(1)
  final String id = "${DateTime.now().millisecondsSinceEpoch}";
  @HiveField(2)
  String text;
  @HiveField(3)
  int red;
  @HiveField(4)
  int green;
  @HiveField(5)
  int blue;
  @HiveField(6)
  double opacity;
  @HiveField(7)
  int lastNoteCorrectmillisecondsSinceEpoch;


  Note(this.text, this.red, this.green, this.blue, this.opacity,this.lastNoteCorrectmillisecondsSinceEpoch);

  @override
  String toString() {
    return 'Note{id: $id, text: $text}';
  }
}
