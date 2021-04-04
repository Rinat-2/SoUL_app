import 'package:flutter/foundation.dart';

class NumberTab extends ChangeNotifier{
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  set selectedTab(int value) {
    _selectedTab = value;
    notifyListeners();
  }
}