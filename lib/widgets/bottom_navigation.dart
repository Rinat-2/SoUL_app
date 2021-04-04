import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/classes.dart';
import 'package:ui/models/free_lesson.dart';
import 'package:ui/models/group.dart';
import 'package:ui/models/group_name.dart';
import 'package:ui/models/number_tab.dart';
import 'package:ui/models/tick.dart';
import 'package:ui/screens/classes_screen.dart';
import 'package:ui/screens/creator_screen.dart';
import 'package:ui/screens/home_screen.dart';
import 'package:ui/screens/setting_screen.dart';
import 'package:ui/screens/tasks_screen.dart';
import 'package:ui/services/notifications.dart';
import 'package:ui/services/settings.dart';

import '../user.dart';

class BottomNavigation extends StatelessWidget {
  bool setNotifications = false;
  List<Widget> _pages = [
    HomeScreen(),
    CalendarPage(),

    TaskPage(),
    SettingScreen()
  ];
  List<BottomNavigationBarItem> tabs = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        size: 30.0,
      ),
      title: SizedBox.shrink(),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.calendar_today,
        size: 30.0,
      ),
      title: SizedBox.shrink(),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.import_contacts, //homework

        size: 30.0,
      ),
      title: SizedBox.shrink(),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
        size: 30.0,
      ),
      title: SizedBox.shrink(),
    ),
  ];
  final _firestoreInstance = Firestore.instance;

  //Стрим с уроками
  Stream<List<Classes>> loadClasses() {
    Stream<QuerySnapshot> data =
        _firestoreInstance.collection('lessons').snapshots();
    Stream<List<Classes>> lessons =
        data.map((event) => event.documents).map((docs) {
      var lessons =
          docs.map((e) => e.data).map((e) => Classes.fromJson(e)).toList();
      lessons
          .sort((l1, l2) => l1.time.toString().compareTo(l2.time.toString()));
      return lessons;
    });

    return lessons;
  }
  Stream<List<FreeLesson>> loadFreeLessons() {
    Stream<QuerySnapshot> data =
    _firestoreInstance.collection('free_lessons').snapshots();
    Stream<List<FreeLesson>> lessons =
    data.map((event) => event.documents).map((docs) {

      var lessons =
      docs.map((e) =>  FreeLesson.fromJson(e.documentID,e.data)).toList();
      lessons
          .sort((l1, l2) => l1.date.toString().compareTo(l2.date.toString()));
      return lessons;
    });

    return lessons;
  }

  //Стрим с группами
  Stream<List<Group>> loadGroups() {
    Stream<QuerySnapshot> data =
        _firestoreInstance.collection('groups').snapshots();
    Stream<List<Group>> groups =
        data.map((event) => event.documents).map((docs) {
      var lessons =
          docs.map((e) => e.data).map((e) => Group.fromJson(e)).toList();

      return lessons;
    });

    return groups;
  }

  Stream<GroupName> getUserGroupName(User user) {
    String mail = user.email;
    Stream<QuerySnapshot> data =
        _firestoreInstance.collection('users').snapshots();
    //Берем всех пользователей из FS
    Stream<GroupName> groupName =
        data.map((event) => event.documents).map((docs) {
      //get first user where = Firebase user mail == Collection user mail
      var currentUser =
          docs.map((e) => e.data).where((user) => user["email"] == mail).first;
      print(currentUser);

      return GroupName(currentUser['group']);
    });
    // var docs = (await data.getDocuments()).documents;
    // //Находим  юзера
    // var jsonUser = docs.where((element) => element.data["email"]==mail).first;
    // String groupName = jsonUser["group"];
    //Смотрим в какой он группе
    //GroupName обертка для Provider
    return groupName;
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: NumberTab()),
        StreamProvider(create: (c) => loadClasses()),
        StreamProvider(create: (c) => loadFreeLessons()),
        StreamProvider(create: (c) => loadGroups()),
        FutureProvider(create: (c) => SettingsController().init()),
        FutureProvider(create: (c) => initNotifications()),
        StreamProvider(create: (c) => getUserGroupName(user)),
        StreamProvider<Tick>(create: (c) => Stream.periodic(Duration(seconds: 1)).map((event) => Tick()),),
      ],
      child: Consumer<Settings>(builder: (context,settings,_){
        if(settings!=null && settings.authedWithGmail) {
          //если пользователь авторизовался через gmail
          //вставка по середине, add или insert не работают поскольку нельзя в процессе изменять количество вкладок, но можно присвоить новый список))))
            tabs=[]..addAll(tabs.getRange(0, 2))..add(BottomNavigationBarItem(
              icon: Icon(
                Icons.add_alert,
                size: 30.0,
              ),
              title: SizedBox.shrink(),
            ))..addAll(tabs.getRange(2, tabs.length));
            _pages.insert(2, CreatorScreen());

        }
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Consumer5<Tick,NumberTab, List<Classes>, List<FreeLesson>,
              FlutterLocalNotificationsPlugin>(
              builder: (context,tick, numberTab, classess,freeLessons,
                  notificationPlugin, _) {

                if (classess != null &&

                    notificationPlugin != null &&
                    !setNotifications) {
                  setNotifications = true;


                  if (settings.showingNotifications) {
                    showClassesNotifications(classess, notificationPlugin);
                    showFreeLessonsNotifications(freeLessons, notificationPlugin);
                  }


                }




                return Stack(
                  children: <Widget>[
                    _pages[numberTab.selectedTab],
                    _bottomNavigator(context, numberTab)
                  ],
                );
              }),
        );
      }),
    );
  }

  _bottomNavigator(
      BuildContext context, NumberTab numberTab) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: kTextColor,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).backgroundColor,
          currentIndex: numberTab.selectedTab,
          onTap: (int index) {
            numberTab.selectedTab = index;
          },
          items: tabs,
        ),
      ),
    );
  }
}
//..insert(2,  BottomNavigationBarItem(
//             icon: Icon(
//               Icons.add_alert,
//
//               size: 30.0,
//             ),
//             title: SizedBox.shrink(),
//           ))
