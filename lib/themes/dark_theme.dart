import 'package:flutter/material.dart';
import 'package:thumbnail_youtube/themes/colors.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.grey.shade900,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: primaryDark,
    error: Color(0xFF85120A),
    background: Colors.black,
  ),
  brightness: Brightness.dark,
  dialogBackgroundColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    //color: Colo rs.black,
    elevation: 5,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontFamily: "WORK SANS",
      fontWeight: FontWeight.bold,
    ),
  ),
  primaryTextTheme: TextTheme(),
  inputDecorationTheme: () {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white),
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
