import 'package:flutter/material.dart';

class MyThemes {
  static const primary = Color(0xFF23A11A);
  static const primaryColor = Color(0xFFB40C73);

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[900],
    primaryColorDark: primaryColor,
    colorScheme: const ColorScheme.dark(primary: primary),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(primary: primary),
    dividerColor: Colors.black,
  );
}
