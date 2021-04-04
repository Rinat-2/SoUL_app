import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ui/models/classes.dart';
import 'package:ui/models/free_lesson.dart';

Future<FlutterLocalNotificationsPlugin> initNotifications()async{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
  AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,

  );
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  );
  return flutterLocalNotificationsPlugin;
}
void showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,String subject,DateTime when)async{


  var androidPlatformChannelSpecifics =
  AndroidNotificationDetails('channel',
      'channel name', 'channel description');
  var iOSPlatformChannelSpecifics =
  IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      subject.hashCode,
      subject,
      'Начнется в течении 10 мин',
      when,
      platformChannelSpecifics,androidAllowWhileIdle: true);
}
void showClassesNotifications(List<Classes> classe,FlutterLocalNotificationsPlugin notificationsPlugin){
DateTime now = DateTime.now();
  classe.forEach((c) {
    if(c.time.isAfter(now))
      showNotification(notificationsPlugin,c.subject,c.time.add(Duration(minutes: -10)));
  });
}
void showFreeLessonsNotifications(List<FreeLesson> freeLessons,FlutterLocalNotificationsPlugin notificationsPlugin){
  DateTime now = DateTime.now();
  freeLessons.forEach((c) {
    if (c.date.isAfter(now))
      showNotification(
          notificationsPlugin, c.subject, c.date.add(Duration(minutes: -10)));
  });
}