//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:ui/landing.dart';
import 'package:ui/models/notes.dart';
import 'package:ui/models/note.dart';
//import 'package:ui/screens/create_note.dart';
//import 'package:ui/screens/tasks_screen.dart';
//import 'package:ui/screens/welcome_screen.dart';
import 'package:ui/services/auth.dart';
//import 'package:ui/services/notifications.dart';
//import 'package:ui/services/settings.dart';
import 'package:ui/user.dart';

//import 'package:ui/screens/welcome_screen.dart';

void main() {
  initializeDateFormatting().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return FutureBuilder(
      future: initHive(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: AuthService().currentUser,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SoUL',
              theme: ThemeData(
                primaryColor: Color(0xFF202328),
                accentColor: Color(0xFF63CF93),
                backgroundColor: Color(0xFF12171D),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              localizationsDelegates: [DefaultMaterialLocalizations.delegate],
              home: LandingPage(),
            ),
          );
        }
        return Container();
      },
    );
  }

  Future initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NotesAdapter());
    Hive.registerAdapter(NoteAdapter());
  }
}
