import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: primary,
      systemNavigationBarColor: primary,
    ),
  );
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
  }

  MobileAds.instance.initialize();
  await firebaseInitialization;
  await FirebaseMessagingApi().initNotifications();

  String data = await getThemeModePrefs();
  DateTime rewared = await getAdsDateTime();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(datetimeAds: rewared),
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
          child: ThmbHomePage(),
        ),
      ),
    ),
  );
}
