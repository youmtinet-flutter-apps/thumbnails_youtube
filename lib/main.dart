import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/app.dart';
import 'package:thumbnail_youtube/themes/colors.dart';
import 'package:thumbnail_youtube/themes/dark_theme.dart';
import 'package:thumbnail_youtube/providers.dart';
import 'package:thumbnail_youtube/utils.dart';
// import 'package:wakelock/wakelock.dart';
import 'themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: primaryColor,
    ),
  );
  var data = await getPreferences();
  consoleLog(data);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<RThemeModeProvider>(
          create: (context) => RThemeModeProvider(isDarkMode: false),
        ),
      ],
      child: ThemeProvider(
        initTheme: data == Brightness.dark.name ? darkTheme : lightTheme,
        duration: const Duration(milliseconds: 1001),
        child: /* Builder(builder: (context) {
          return  */
            const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          /* darkTheme: darkTheme,
            theme: lightTheme, */
          title: 'Thumbnails YouTube',
          home: ThmbHomePage(),
        ) /* ;
        }) */
        ,
      ),
    ),
  );
}
