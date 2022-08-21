import 'package:flutter/material.dart';

class MyThemes {
  MyThemes._();
  static final primaryColor = Colors.blue.shade300;

  static final darkTheme = ThemeData(
    // This is the theme of your application.
    primaryColorDark: primaryColor,
    backgroundColor: Colors.black,
    brightness: Brightness.dark,
    //dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    // This is the theme of your application.
    primaryColorDark: primaryColor,
    backgroundColor: Colors.white,
    //dividerColor: Colors.black,
  );
}
