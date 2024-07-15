import 'package:flutter/material.dart';
import 'package:thumbnail_youtube/themes/colors.dart';

ThemeData theme(bool isDark) {
  Color bg = isDark ? Color(0xFF202020) : Color.fromARGB(255, 214, 214, 214);
  Color fg = !isDark ? Color(0xFF202020) : Color.fromARGB(255, 214, 214, 214);
  Color error = Color(0xFF85120A);
  return ThemeData(
    scaffoldBackgroundColor: bg,
    useMaterial3: true,
    colorScheme: isDark
        ? ColorScheme.dark(
            primary: primaryDark,
            error: error,
            background: bg,
          )
        : ColorScheme.light(
            primary: primary,
            error: error,
            background: bg,
          ),
    brightness: isDark ? Brightness.dark : Brightness.light,
    dialogBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      //   color: fg,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: fg,
        fontFamily: "WORK SANS",
        fontWeight: FontWeight.bold,
      ),
    ),
    // primaryTextTheme: TextTheme(),
    inputDecorationTheme: () {
      OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: fg),
        gapPadding: 10,
      );
      return InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.only(
          right: 32,
          top: 10,
          left: 32,
          bottom: 10,
        ),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
      );
    }(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
