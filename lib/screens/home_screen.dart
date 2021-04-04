import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/classes.dart';
import 'package:ui/models/number_tab.dart';
import 'package:ui/widgets/build_classes.dart';
//import 'package:ui/widgets/build_classes.dart';
import 'package:ui/widgets/header.dart';
//import 'package:ui/widgets/recents_alerts.dart';
import 'package:ui/widgets/recents_homeworks.dart';

class HomeScreen extends StatefulWidget {


  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Header(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "Здравствуйте, здесь вы можете увидеть актуальное расписание",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Container(
          padding: EdgeInsets.all(35.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Расписание занятий",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              Lesson(DateTime.now(),3),

            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {

  }
}
