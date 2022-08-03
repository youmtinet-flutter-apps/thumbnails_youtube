import 'package:flutter/material.dart';

class RThemeModeProvider extends ChangeNotifier {
  bool isDarkMode;

  RThemeModeProvider({required this.isDarkMode});

  void toggleThemeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
