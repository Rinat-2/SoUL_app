import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/classes.dart';
import 'package:ui/models/free_lesson.dart';
import 'package:ui/models/group.dart';
import 'package:ui/models/group_name.dart';
import 'package:ui/models/tick.dart';
import 'package:ui/screens/corrector_screen.dart';
import 'package:ui/screens/creator_screen.dart';
import 'package:ui/services/notifications.dart';
import 'package:ui/services/settings.dart';

import '../user.dart';

class Lesson extends StatelessWidget {
  DateTime day;
  int countOnDay;

  Lesson(this.day, [this.countOnDay]);

  final _firestoreInstance = Firestore.instance;

  final DateFormat dateFormat = DateFormat("hh:mm a");

  @override
  Widget build(BuildContext con) {
    return Consumer3<List<Classes>, List<FreeLesson>, GroupName>(
        builder: (context, classe, freeLessons, groupName, _) {
      final User user = Provider.of<User>(context);

      if (classe != null &&
          groupName != null &&
          freeLessons != null &&
          user != null) {
        classe = classe
            .where((element) {
              var time = element.time;
              return time.year == day.year &&
                  time.month == day.month &&
                  time.day == day.day;
            })
            .where((classes) => classes.group == groupName.name)

            .toList();

        // classe= classe.skip(countOnDay!=null && classe.length>countOnDay?classe.length-countOnDay:0).toList();

        freeLessons = freeLessons
            .where((lesson) => lesson.userMail == user.email)
            .where((element) {
              var time = element.date;
              return time.year == day.year &&
                  time.month == day.month &&
                  time.day == day.day;
            })
            .toList();
        // freeLessons= freeLessons.skip(countOnDay!=null&& freeLessons.length>countOnDay?freeLessons.length-countOnDay:0).toList();

        if (classe.isNotEmpty) {

          return Consumer<Tick>(builder: (c, tick, _) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: classe.length,
              itemBuilder: (BuildContext context, int index) {
                Classes c = classe[index];

                isPassed(c,classes);
                return getLesson(context, c, classe);
              },
            );
          });
        } else if (freeLessons.isNotEmpty) {

          return Consumer<Tick>(builder: (context, tick, _) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: freeLessons.length,
              itemBuilder: (BuildContext context, int index) {
                FreeLesson c = freeLessons[index];

                isFreePassed(c,freeLessons);
                return getFreeLesson(con, c, freeLessons);
              },
            );
          });
        } else {
          return Center(
            child: Column(
              children: [
                Text(
                  "Выходной день",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )
              ],
            ),
          );
        }
      }

      return Center(
        child: CircularProgressIndicator(),
      );
      // }
// return Center(child: CircularProgressIndicator(),);
    });
  }

  bool isFreePassed(FreeLesson c,List<FreeLesson> lessons) {
    DateTime now = DateTime.now();
    // return now.isAfter(c.date) ||now.isAfter(c.date)&& now.difference(c.date).inMinutes >= 59 ;
    return now.isAfter(c.date) && !isFreeLast(c, lessons);


  }

  bool isFreeHappening(FreeLesson freeLesson) {
    DateTime now = DateTime.now();
    DateTime finishedTime = freeLesson.date.add(Duration(hours: 1));
    return now.difference(freeLesson.date).inMinutes <= 59 &&
        now.difference(finishedTime).inMinutes >= -59;
  }

  bool isHappening(Classes classes) {
    DateTime now = DateTime.now();
    DateTime finishedTime = classes.time.add(Duration(hours: 1));
    return now.difference(classes.time).inMinutes <= 59 &&
        now.difference(finishedTime).inMinutes >= -59;
  }

 bool isPassed(Classes c,List<Classes> lessons) {
   DateTime now = DateTime.now();
   // return now.difference(c.time).inMinutes >= 59;
   return now.isAfter(c.time) && !isLast(c, lessons);

 }

  //Свой набор методов для FreeLesson, если нужно сократить, можно создать общий предок
  _getFreeTime(FreeLesson c, context,List<FreeLesson> lessons) {
    return Container(
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isFreePassed(c,lessons)
              ? Theme.of(context).accentColor.withOpacity(0.3)
              : Theme.of(context).accentColor,
          // width: 2.0,
        ),
      ),
      child: _getFreeChild(c, context,lessons),
    );
  }
  bool isFreeLast(FreeLesson c,List<FreeLesson> lessons){
    var happening =   lessons.where((element) => isFreeHappening(element));
    return   happening.isNotEmpty &&  happening.last.date == c.date;
  }
  bool isLast(Classes c,List<Classes> lessons){
    var happening =   lessons.where((element) => isHappening(element));
    return   happening.isNotEmpty &&  happening.last.time == c.time;
  }
  _getFreeChild(FreeLesson c, context,List<FreeLesson> lessons) {
    if (isFreePassed(c,lessons)) {
      return Icon(
        Icons.check,
        color: isFreePassed(c,lessons)
            ? Theme.of(context).accentColor.withOpacity(0.3)
            : Theme.of(context).accentColor,
        size: 15.0,
      );
    } else if (    isFreeLast(c, lessons) ) {
      return Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.circle,
        ),
      );
    }
    return null;
  }

  _getTime(Classes c, context,List<Classes> lessons) {
    return Container(
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isPassed(c,lessons)
              ? Theme.of(context).accentColor.withOpacity(0.3)
              : Theme.of(context).accentColor,
          // width: 2.0,
        ),
      ),
      child: _getChild(c, context,lessons),
    );
  }

  _getChild(Classes c, context,List<Classes> lessons) {
    if (isPassed(c,lessons)) {
      return Icon(
        Icons.check,
        color: isPassed(c,lessons)
            ? Theme.of(context).accentColor.withOpacity(0.3)
            : Theme.of(context).accentColor,
        size: 15.0,
      );
    } else if (isHappening(c)) {
      return Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.circle,
        ),
      );
    }
    return null;
  }

  void onTapByFreeLesson(BuildContext context, FreeLesson freeLesson,
      FlutterLocalNotificationsPlugin plugin) {
    Navigator.push(context,
            MaterialPageRoute(builder: (c) => CorrectorScreen(freeLesson)))
        .then((value) => showFreeLessonsNotifications([freeLesson], plugin));
  }

  void removeFreeLesson(String id) {
    _firestoreInstance.collection('free_lessons').document(id).delete();
  }

  Widget getLesson(BuildContext context, Classes c, List<Classes> classes) {
    var happening =   classes.where((element) => isHappening(element));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 8),
              Text(
                "${dateFormat.format(c.time)}",
                style: TextStyle(
                  color:
                  isPassed(c,classes) ? Colors.white.withOpacity(0.2) : Colors.white,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(width: 20.0),
              _getTime(c, context,classes),
              SizedBox(width: 20.0),
              Text(
                c.subject,
                style: TextStyle(
                  color:
                  isPassed(c,classes) ? Colors.white.withOpacity(0.2) : Colors.white,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(width: 20.0),
            happening.isNotEmpty &&  happening.last.time == c.time
                  ? Container(
                      height: 25.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                          child: Text(
                        "Now",
                        style: TextStyle(color: Colors.white),
                      )),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 117.0, bottom: 20.0),
                width: 2,
                height: 100.0,
                color: isPassed(c,classes) ? kTextColor.withOpacity(0.3) : kTextColor,
              ),
              SizedBox(width: 28.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: isPassed(c,classes)
                            ? Theme.of(context).accentColor.withOpacity(0.3)
                            : Theme.of(context).accentColor,
                        size: 20.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        c.type,
                        style: TextStyle(
                          color: isPassed(c,classes)
                              ? kTextColor.withOpacity(0.3)
                              : kTextColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: isPassed(c,classes)
                            ? Theme.of(context).accentColor.withOpacity(0.3)
                            : Theme.of(context).accentColor,
                        size: 20.0,
                      ),
                      SizedBox(width: 8.0),
                      Wrap(
                        children: [
                          Text(
                            c.teacherName,
                            style: TextStyle(
                              color: isPassed(c,classes)
                                  ? kTextColor.withOpacity(0.3)
                                  : kTextColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 20.0),
        ],
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget getFreeLesson(
      BuildContext context, FreeLesson freeLesson, List<FreeLesson> lessons) {
    var happening =  lessons.where((element) => isFreeHappening(element));
    return Consumer<FlutterLocalNotificationsPlugin>(
        builder: (context, notPlugin, _) {
      return GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onTap: () {
                    removeFreeLesson(freeLesson.id);
                  },
                ),
                SizedBox(width: 8),
                Text(
                  "${dateFormat.format(freeLesson.date)}",
                  style: TextStyle(
                    color: isFreePassed(freeLesson,lessons)
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(width: 20.0),
                _getFreeTime(freeLesson, context,lessons),
                SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    freeLesson.subject,
                    style: TextStyle(
                      color: isFreePassed(freeLesson,lessons)
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
             isFreeLast(freeLesson, lessons)
                    ? Container(
                        height: 25.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                            child: Text(
                          "Now",
                          style: TextStyle(color: Colors.white),
                        )),
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    Icon(
                      Icons.description,
                      color: isFreePassed(freeLesson,lessons)
                          ? Theme.of(context).accentColor.withOpacity(0.3)
                          : Theme.of(context).accentColor,
                      size: 20.0,
                    )
                  ],
                ),
                SizedBox(width: 8.0),
                Expanded(
                    child: Text(
                  freeLesson.description,
                  style: TextStyle(
                    color: isFreePassed(freeLesson,lessons)
                        ? kTextColor.withOpacity(0.3)
                        : kTextColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ],
            ),
            SizedBox(height: 40.0),
          ],
        ),
        onTap: () {
          onTapByFreeLesson(context, freeLesson, notPlugin);
        },
      );
    });
  }
}
