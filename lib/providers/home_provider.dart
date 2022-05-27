import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedNavbar = 0;
  int get selectedNavbar => _selectedNavbar;

  void changeSelectedNavBar(int index) {
    _selectedNavbar = index;
    notifyListeners();
  }
}
