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
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: primaryColor,
    ),
  );
  final collection = firebaseFirestore.collection('statistics');
  final dataCollection = await collection.get();
  var firebaseHistory = dataCollection.docs.map((e) => VideoThumbnailMetataData.fromJson(e.data())).toList();
  /* var mq = RsolutionEnum.mqdefault;
  var futureTest = await Future.wait(firebaseHistory.map((h) => resolu(mq, h)));
  var validOnlyy = futureTest
      .where(
        (listRes) => listRes.statusCode == 200,
      )
      .map((e) => e.video)
      .toList();
  log(firebaseHistory.length.toString());
  log(validOnlyy.length.toString()); */
  var historic = await getLocalHistoric();
  var data = await getThemeModePrefs();
  var validOnly = firebaseHistory;
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(history: historic, firebaseHistory: validOnly),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.topLevel,
        actions: const {},
        popGesture: true,
        theme: lightTheme,
        darkTheme: darkTheme,
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
    ),
  );
}

/* darkTheme: darkTheme,
theme: lightTheme, */