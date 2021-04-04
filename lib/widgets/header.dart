import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.school,
            color: Colors.white,
            size: 40.0,
          ),
          Text(
            "SoUL",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
