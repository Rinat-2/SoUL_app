import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/classes.dart';
import 'package:ui/services/auth.dart';
import 'package:ui/services/notifications.dart';
import 'package:ui/services/settings.dart';
import 'package:ui/widgets/SettingsHeader.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool hasNotifications = true;
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      SettingsHeader(),
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
            Consumer3<List<Classes>, Settings, FlutterLocalNotificationsPlugin>(
                builder: (context, classess, settings, notificationPlugin, _) {
              hasNotifications = settings.showingNotifications;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          Text(
                            "Включить/Отключить уведомления",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              CupertinoSwitch(
                                value: hasNotifications,
                                onChanged: (v) {
                                  setState(() {
                                    hasNotifications = v;
                                    settings.showingNotifications = v;
                                    if (v) {
                                      if (classess != null &&
                                          settings != null &&
                                          notificationPlugin != null) {
                                        // var notifyClasses =classess.where((element) => !settings.wereNotifications.contains(element.time.toString())).toList();
                                        // notifyClasses.forEach((element) {settings.addIdNotificationThatWas(element.time.toString());});
                                        // showClassesNotifications(classess,notificationPlugin);
                                      }
                                    } else {
                                      notificationPlugin.cancelAll();
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      SizedBox(
        height: 100,
      ),
      /*Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        Text(
          'О приложении',
          style: TextStyle(
              //fontFamily: 'ZillaSlab',
              fontSize: 24,
              color: (Colors.white)),
        ),
      ]),*/
      Container(
        padding: EdgeInsets.all(35.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          /*padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30.0),*/
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'О приложении: ',
                style: TextStyle(
                    //fontFamily: 'ZillaSlab',
                    fontSize: 24,
                    color: (Colors.white)),
              ),
              Container(
                height: 10,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Developed by Rinat',
                  style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                ),
              )),
              Container(
                height: 40,
              ),
              Center(
                child: Text('Связаться с разработчиком: '.toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
              ),
              /*Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Rinat',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              )),*/
              Container(
                alignment: Alignment.center,
                child: OutlineButton.icon(
                  icon: Icon(OMIcons.link),
                  label: Text('Telegram',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          fontSize: 20,
                          color: Colors.grey.shade500)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: openTelegram,
                ),
              ),
              Container(
                height: 30,
              ),
              Center(
                child: Text('Made With'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlutterLogo(
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Flutter',
                          style:
                              TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
      )
    ]);
  }

  void openTelegram() {
    launch('https://t.me/Rinat_M');
  }
}
