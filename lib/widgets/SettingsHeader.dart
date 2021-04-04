import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/services/settings.dart';

import '../auth.dart';

class SettingsHeader extends StatefulWidget {
  SettingsHeader({Key key}) : super(key: key);

  @override
  _SettingsHeaderState createState() => _SettingsHeaderState();
}

class _SettingsHeaderState extends State<SettingsHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
        builder: (context, settings, _) => Padding(
              padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Настройки",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    child: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).accentColor,
                      size: 40,
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) => settings
                          .authWithGmail(false)
                          .then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => AuthorizationPage()))));
                    },
                  )
                ],
              ),
            ));
  }
}
