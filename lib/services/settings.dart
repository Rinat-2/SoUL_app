import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../constants.dart';


class SettingsController {

   Future<Settings>  init()async{
   bool showingNotifications = await _getShowingNotifications();
   bool authWithGmail = await _getAuthWithGmail();

    return Settings(this,showingNotifications,authWithGmail);
  }

   Future<bool> _getAuthWithGmail()async{
     return (await _Prefernces.getPreferences()).getBool(IS_AUTHED_WITH_GMAIL)??false;
   }
   void saveShowingNotifications(bool val)async{
     (await _Prefernces.getPreferences()).setBool(IS_SHOWING_NOTIFICATIONS, val);
   }
  Future saveAuthWithGmail(bool val)async{
    (await _Prefernces.getPreferences()).setBool(IS_AUTHED_WITH_GMAIL, val);
  }
   Future<bool> _getShowingNotifications()async{
  return (await _Prefernces.getPreferences()).getBool(IS_SHOWING_NOTIFICATIONS)??true;
}
}
class _Prefernces {
  static SharedPreferences _sharedPreferences;
  static Future<SharedPreferences> getPreferences()async{
    if(_sharedPreferences == null){
      _sharedPreferences = await SharedPreferences.getInstance();

    }
    return _sharedPreferences;
  }
}
class Settings extends ChangeNotifier  {

  bool _showingNotifications;
  bool _authWithGmail;


  bool get authedWithGmail => _authWithGmail;

  Future authWithGmail(bool value)async {
    _authWithGmail = value;
    notifyListeners();
    await settingsController.saveAuthWithGmail(value);
  }

  SettingsController settingsController;


   bool get showingNotifications => _showingNotifications;

   set showingNotifications(bool value) {
    _showingNotifications = value;
    notifyListeners();
    settingsController.saveShowingNotifications(value);
  }

   Settings(this.settingsController,this._showingNotifications,this._authWithGmail);


}