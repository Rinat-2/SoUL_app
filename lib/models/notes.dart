import 'package:hive/hive.dart';
import 'package:ui/models/note.dart';
part 'notes.g.dart';
@HiveType(typeId: 2)
class Notes extends HiveObject{
  @HiveField(0)
List<Note> _notes ;
void addNote(Note note)=>_notes.add(note);

void removeById(String id)=>_notes.removeWhere((n) => n.id==id);

Notes(this._notes){
  _notes = _notes ?? [];
}

  void remove(Note note)=>_notes.remove(note);

List<Note> get notes => _notes;

@override
  String toString() {
    return 'Notes{_notes: $_notes}';
  }
}