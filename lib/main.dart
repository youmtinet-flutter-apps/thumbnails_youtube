import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thumbnail_youtube/themes/colors.dart';
import 'package:thumbnail_youtube/themes/dark_theme.dart';
import 'package:thumbnail_youtube/utils/utils.dart';
import 'app.dart';
import 'utils/constants.dart';
import 'themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization;
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: primaryColor,
    ),
  );
  var data = await getPreferences();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.topLevel,
      title: 'Thumbnails YouTube',
      home: ThemeProvider(
        initTheme: data == Brightness.dark.name ? darkTheme : lightTheme,
        duration: const Duration(milliseconds: 1001),
        child: Builder(builder: (context) {
          return ThemeSwitchingArea(
            child: Builder(builder: (context) {
              return const ThmbHomePage();
            }),
          );
        }),
      ),
    ),
  );
}

/* darkTheme: darkTheme,
theme: lightTheme, */