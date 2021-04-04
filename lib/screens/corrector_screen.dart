import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:ui/models/free_lesson.dart';
import 'package:ui/models/number_tab.dart';
import 'package:ui/widgets/TaskHeader.dart';
import 'package:ui/widgets/header.dart';

import '../user.dart';

class CorrectorScreen extends StatefulWidget {
  FreeLesson freeLesson;
  @override
  State<StatefulWidget> createState() => CorrectorScreenState();

  CorrectorScreen(this.freeLesson);
}

class CorrectorScreenState extends State<CorrectorScreen> {
  InputDecoration _inputDecoration;
  TextStyle _textStyle;
  TextStyle _fieldStyle;
  TextEditingController _subject = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _description = TextEditingController();
  final _firestoreInstance = Firestore.instance;
FreeLesson get freeLesson =>widget.freeLesson;
  @override
  void initState() {
   _subject.text = freeLesson.subject;
   _date.text =freeLesson.date.toString();
   _description.text = freeLesson.description;
   print(freeLesson.id);

  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    InputBorder inputBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));
    _inputDecoration = InputDecoration(
        border: inputBorder,
        focusedBorder: inputBorder,
        disabledBorder: inputBorder,
        enabledBorder: inputBorder);
    _textStyle = TextStyle(color: Colors.grey, fontSize: 18);
    _fieldStyle = TextStyle(color: Colors.white, fontSize: 18);

    return  Scaffold(        backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
      children: [
        Header(),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Название урока",
                      style: _textStyle,
                      textAlign: TextAlign.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: _inputDecoration,
                      style: _fieldStyle,
                      controller: _subject,
                    ),
                    flex: 3,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Описание",
                      style: _textStyle,
                      textAlign: TextAlign.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: _inputDecoration,
                      style: _fieldStyle,
                      controller: _description,
                    ),
                    flex: 3,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Начало урока",
                      style: _textStyle,
                      textAlign: TextAlign.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: TextFormField(
                        decoration: _inputDecoration,
                        enabled: false,
                        style: _fieldStyle,
                        controller: _date,
                      ),
                      onTap: () {

                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 1, 1),
                            maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
                              _date.text=date.toString();
                            }, currentTime: DateTime.now(), locale: LocaleType.ru);
                      },
                    ),
                    flex: 3,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          freeLesson.description = _description.text;
                          freeLesson.subject = _subject.text;
                          freeLesson.date = DateTime.parse(_date.text);
                          _firestoreInstance.collection('free_lessons').document(freeLesson.id).updateData(freeLesson.toJson()).then((value) {
                            Navigator.pop(context);
                            _subject.clear();
                            _description.clear();
                            _date.clear();
                          });







                        },
                        child: Text(
                          "Изменить",
                          style: TextStyle(fontSize: 20),
                        ),
                      ))
                ],
              )
            ],
          ),
        )
      ],
    ),);
  }

  FreeLesson getFreeLesson(User user) =>
      FreeLesson(_subject.text, _description.text, DateTime.parse(_date.text), user.email);
}
