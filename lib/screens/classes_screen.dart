import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:ui/constants.dart';
import 'package:ui/widgets/build_classes.dart';
import 'package:ui/widgets/header.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Header(),
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                locale: 'ru_RU',
                initialCalendarFormat: CalendarFormat.week,

                onDaySelected: (day, events,_) {
                  setState(() {
                    selectedDay = day;
                  });
                },
                calendarStyle: CalendarStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  formatButtonDecoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20)),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  formatButtonShowsNext: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarController: _controller,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(40.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Lesson(selectedDay),
            ],
          ),
        ),
      ],
    );
  }
}
