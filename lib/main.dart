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
//   var historic = await getLocalHistoric();
  var data = await getThemeModePrefs();
  var rewared = await getRewardDateTime();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(datetimereward: rewared),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.topLevel,
        actions: {},
        popGesture: true,
        theme: theme(false),
        darkTheme: theme(true),
        title: 'Thumbnails YouTube',
        home: ThemeProvider(
          initTheme: theme(data == Brightness.dark.name),
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
