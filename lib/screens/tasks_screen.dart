import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/notes.dart';
import 'package:ui/widgets/TaskHeader.dart';
import 'package:ui/widgets/note_view.dart';

import 'create_note.dart';

class TaskPage extends StatefulWidget {
  TaskPage({Key key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

//в файле main добавлена инициализация плагина hive (флаттеровская реализация nosql бд )
//ниже создается коробка в которой мы храним объекты  по index и id
//а дальше читайте про hive)))
//после  изменениния HiveObject следует вызывать flutter pub run build_runner build
class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox(NOTES),
      builder: (BuildContext context, AsyncSnapshot<Box> snap) {
        if (snap.connectionState == ConnectionState.done) {
          Box box = snap.data;
          Notes noteContainer = box.get(NOTE_LIST);
          if (noteContainer == null) {
            //при первом запуске
            noteContainer = Notes([]);
            box.put(NOTE_LIST, noteContainer);
          }
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              children: [
                TaskHeader(),
                Expanded(child: NoteView(box)),
                SizedBox(
                  height: 70,
                )
              ],
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateNote(box)))
                      .then((new_box) => setState(() {}));
                },
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
        );
      },
    );
  }
}
