import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/notes.dart';
import 'package:ui/models/note.dart';
import 'package:ui/screens/create_note.dart';

class NoteView extends StatefulWidget {
  Box box;

  NoteView(this.box);

  @override
  State<StatefulWidget> createState() {
    return NoteViewState();
  }
}

class NoteViewState extends State<NoteView> {
  Box get box => widget.box;

  @override
  Widget build(BuildContext context) {
    Notes noteContainer = box.get(NOTE_LIST);

    if (noteContainer.notes.isEmpty) {
      return plug();
    }
    return GridView.builder(
        itemCount: noteContainer.notes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20),
        itemBuilder: (context, index) => newNote(noteContainer.notes[index]));
  }

  Widget newNote(Note e) {
    return InkWell(
      child: Card(
        color: Color.fromRGBO(e.red, e.green, e.blue, e.opacity),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(
                    e.text,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),)
                ],
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy kk:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            e.lastNoteCorrectmillisecondsSinceEpoch)),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateNote.openCurrent(box, e)))
            .then((value) {
          setState(() {});
        });
      },
    );
  }

  Widget plug() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "Здесь вы можете увидеть ваши заметки или же создавать их!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 200.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
              size: 150,
            ),
            Text(
              "Список пуст",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ],
        )
      ],
    );
  }
}
