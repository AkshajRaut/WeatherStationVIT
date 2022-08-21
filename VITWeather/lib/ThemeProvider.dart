import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  set setDarkMode(bool val) {
    themeMode = val ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
