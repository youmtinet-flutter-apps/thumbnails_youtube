import 'package:flutter/material.dart';
import 'package:thumbnail_youtube/themes/colors.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.light(primary: primaryColor),
  errorColor: Colors.red,
  dialogBackgroundColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    //color: Colo rs.black,
    foregroundColor: Colors.white,
    elevation: 5,
    shadowColor: Colors.white.withOpacity(0.3),
    centerTitle: true,
    titleTextStyle: const TextStyle(
      fontSize: 16,
      fontFamily: "WORK SANS",
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  primaryTextTheme: const TextTheme(),
  inputDecorationTheme: () {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: Colors.black),
      gapPadding: 10,
    );
    return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      helperStyle: const TextStyle(color: Colors.black),
      labelStyle: const TextStyle(color: Colors.black),
      prefixStyle: const TextStyle(color: Colors.black),
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
