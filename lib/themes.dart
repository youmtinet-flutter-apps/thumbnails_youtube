import 'package:flutter/material.dart';

class MyThemes {
  static const primary = Color(0xFF23A11A);
  static const primaryColor = Color(0xFFB40C73);

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey[900],
    primaryColorDark: primaryColor,
    splashColor: Colors.brown,
    focusColor: Colors.red,
    hoverColor: Colors.amber,
    highlightColor: Colors.indigo,
    colorScheme: const ColorScheme.dark(primary: primary),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    primaryColorDark: primaryColor,
    splashColor: const Color(0xFF487963),
    focusColor: const Color(0xFFCE36F4),
    hoverColor: const Color(0xFF0766FF),
    highlightColor: const Color(0xFFB5B13F),
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(primary: primary),
    dividerColor: Colors.black,
  );
}
