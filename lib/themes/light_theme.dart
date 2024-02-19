import 'package:flutter/material.dart';
import 'package:thumbnail_youtube/themes/colors.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: primary,
    error: Color(0xFF85120A),
    background: Color(0xFFFFFFFF),
  ),
  dialogBackgroundColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    //color: Colo rs.black,
    foregroundColor: Colors.white,
    elevation: 5,
    shadowColor: Colors.white.withOpacity(0.3),
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontFamily: "WORK SANS",
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  primaryTextTheme: TextTheme(),
  inputDecorationTheme: () {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black),
      gapPadding: 10,
    );
    return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      helperStyle: TextStyle(color: Colors.black),
      labelStyle: TextStyle(color: Colors.black),
      prefixStyle: TextStyle(color: Colors.black),
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
