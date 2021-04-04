import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/notes.dart';
import 'package:ui/models/note.dart';

class CreateNote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateNoteState();
  }

  final Box box;
  Note note;

  CreateNote(this.box);

  CreateNote.openCurrent(this.box, this.note);
}

class CreateNoteState extends State<CreateNote> {
  TextEditingController noteTextController = TextEditingController();
  Color currentColor = Colors.red;
  SpeechToText speech = SpeechToText();

  Box get box => widget.box;

  Note get note => widget.note;

  Widget circleColor(Color color) {
    return InkWell(
      child: Padding(
        child: CircleAvatar(
          radius: color == currentColor ? 18 : 15,
          backgroundColor: color,
        ),
        padding: EdgeInsets.all(5),
      ),
      onTap: () {
        setState(() {
          currentColor = color;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (note != null) {
      noteTextController.text = note.text;
      currentColor =
          Color.fromRGBO(note.red, note.green, note.blue, note.opacity);
    }
    speech.initialize(
        onStatus: (status) {},
        onError: (error) {
          print(error);
        });

  }

  @override
  Widget build(BuildContext context) {
    var border = UnderlineInputBorder(
        borderSide:
            BorderSide(width: 0, color: Theme.of(context).backgroundColor));
    return SafeArea(
        child: Scaffold(
      floatingActionButton: Builder(builder: (

       BuildContext context) {
        if(speech.isAvailable){

          return Padding(
            child: FloatingActionButton(
              onPressed: () {
                if (speech.isListening) {
                  setState(() {
                    speech.stop();
                  });
                } else {
                  setState(() {});

                  speech.listen(
                    onResult: (result) {
                      print(result);
                      setState(() {});

                      if (result.finalResult) {
                        if (noteTextController.text.isNotEmpty) {
                          noteTextController.text =
                              noteTextController.text +
                                  " " +
                                  result.recognizedWords;
                        } else {
                          noteTextController.text =
                              noteTextController.text +
                                  result.recognizedWords;
                        }
                      } else {

                      }
                    },
                  );
                }
              },
              child: Icon(
                speech.isListening ? Icons.mic_off : Icons.mic,
                color: Colors.white,
              ),
            ),
            padding: EdgeInsets.only(bottom: 36),
          );
        }
        return Padding(
          child: FloatingActionButton(
            onPressed: () {
              if (speech.isListening) {
                setState(() {
                  speech.stop();
                });
              } else {
                speech.listen(
                  localeId: "ru_RU",
                  onResult: (result) {
                    print(result);
                    setState(() {});

                    if (result.finalResult) {
                      if (noteTextController.text.isNotEmpty) {
                        noteTextController.text =
                            noteTextController.text +
                                " " +
                                result.recognizedWords;
                      } else {
                        noteTextController.text =
                            noteTextController.text +
                                result.recognizedWords;
                      }
                    } else {

                    }
                  },
                );
              }
              setState(() {});

            },
            child: Icon(
              speech.isListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
          ),
          padding: EdgeInsets.only(bottom: 36),
        );
          return Padding(
            padding: EdgeInsets.only(bottom: 36),
            child: CircularProgressIndicator(),
          );
        },
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomSheet: Container(
        color: Theme.of(context).backgroundColor.withOpacity(0.9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 40,
            ),
            circleColor(Colors.red),
            circleColor(Colors.green),
            circleColor(Colors.yellow),
            circleColor(Colors.blueAccent),
            circleColor(Colors.purple),
            SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
      body: WillPopScope(
          child: Column(children: [
            Expanded(
              child: Container(

                child: TextFormField(
                  minLines: 1,
                  maxLines: 2000,
                  controller: noteTextController,
                  decoration: InputDecoration(
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                      disabledBorder: border,
                      prefixText: "    "),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ]),
          onWillPop: () {
            if (noteTextController.text.isNotEmpty) {
              Notes notes = box.get(NOTE_LIST);
              if (note != null) {
                notes.removeById(note.id);
              }

              notes.addNote(Note(
                  noteTextController.text,
                  currentColor.red,
                  currentColor.green,
                  currentColor.blue,
                  currentColor.opacity,
                  DateTime.now().millisecondsSinceEpoch));
              box.put(NOTE_LIST, notes);

              Navigator.pop(context);
            }
          }),
      appBar: PreferredSize(
        child: Column(
          children: [
            Expanded(
                child: Padding(padding: EdgeInsets.only(top: 20),child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                   Padding(padding: EdgeInsets.all(5),child:  InkWell(
                     child: Icon(
                       Icons.arrow_back,
                       color: Colors.white,
                     ),
                     onTap: () {
                       if (noteTextController.text.isNotEmpty) {
                         Notes notes = box.get(NOTE_LIST);
                         if (note != null) {
                           notes.removeById(note.id);
                         }

                         notes.addNote(Note(
                             noteTextController.text,
                             currentColor.red,
                             currentColor.green,
                             currentColor.blue,
                             currentColor.opacity,
                             DateTime.now().millisecondsSinceEpoch));
                         box.put(NOTE_LIST, notes);
                       }

                       Navigator.pop(context);
                     },
                   ),),
                    Expanded(child: Container()),
                    Padding(padding: EdgeInsets.all(5),child: MaterialButton(
                      onPressed: () {
                        if (note == null) {
                          Navigator.pop(context);
                        } else {
                          Notes notes = box.get(NOTE_LIST);
                          notes.removeById(note.id);
                          box.put(NOTE_LIST, notes);

                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Удалить",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),)
                  ],
                ),))
          ],
        ),
        preferredSize: Size(double.infinity, 60),
      ),
    ));
  }
}
