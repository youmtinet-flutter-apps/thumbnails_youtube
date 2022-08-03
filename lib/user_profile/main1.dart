import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './page/profile_page.dart';
import '../themes.dart';
import './utils/user_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'User Profile';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;

    return ThemeProvider(
      initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
      duration: const Duration(milliseconds: 250),
      child: Builder(
        builder: (context) => const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          home: ProfilePage(),
        ),
      ),
    );
  }
}
