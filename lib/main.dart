import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await firebaseInitialization;
  await FirebaseMessagingApi().initNotifications();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: primary,
      systemNavigationBarColor: primary,
    ),
  );
  var historic = await getLocalHistoric();
  var data = await getThemeModePrefs();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(history: historic),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.topLevel,
        actions: {},
        popGesture: true,
        theme: lightTheme,
        darkTheme: darkTheme,
        title: 'Thumbnails YouTube',
        home: ThemeProvider(
          initTheme: data == Brightness.dark.name ? darkTheme : lightTheme,
          duration: Duration(milliseconds: 1001),
          child: Builder(builder: (context) {
            return ThemeSwitchingArea(
              child: Builder(builder: (context) {
                return ThmbHomePage();
              }),
            );
          }),
        ),
      ),
    ),
  );
}

/* darkTheme: darkTheme,
theme: lightTheme, */