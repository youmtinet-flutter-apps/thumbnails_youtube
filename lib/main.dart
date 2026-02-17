import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/l10n/app_localizations.dart';
import 'package:thumbnail_youtube/lib.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    //
    SystemUiOverlayStyle(
      //
      statusBarColor: primaryColor,
      systemNavigationBarColor: primaryColor,
    ),
  );

  MobileAds.instance.initialize();
  await firebaseInitialization;

  DateTime rewared = await getAdsDateTime();

  runApp(
    ChangeNotifierProvider<AppProvider>(
      create: (BuildContext context) => AppProvider(datetimeAds: rewared),
      child: ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.topLevel,
            actions: <Type, Action<Intent>>{},
            popGesture: true,
            theme: theme(dark: false),
            darkTheme: theme(dark: true),
            onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              //
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: context.watch<AppProvider>().locale,
            home: ThmbHomePage(),
          );
        },
      ),
    ),
  );
}
