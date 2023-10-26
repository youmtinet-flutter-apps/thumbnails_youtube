import 'package:flutter/material.dart';
import 'package:thumbnail_youtube/themes/colors.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColorDark: primaryColor,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    error: Color(0xFF85120A),
  ),
  brightness: Brightness.dark,
  dialogBackgroundColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    //color: Colo rs.black,
    elevation: 5,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontFamily: "WORK SANS",
      fontWeight: FontWeight.bold,
    ),
  ),
  primaryTextTheme: const TextTheme(),
  inputDecorationTheme: () {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: Colors.white),
      gapPadding: 10,
    );
    return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.only(
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
