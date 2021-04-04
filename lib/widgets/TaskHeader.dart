import 'package:flutter/material.dart';
import 'file:///C:/Users/rinat/Documents/SOUL-master/lib/widgets/note_view.dart';

class TaskHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Заметки",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
