import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/providers.dart';
import 'package:thumbnail_youtube/utils.dart';

import 'date_range_picker/example.dart';
import 'themes.dart';

void main() => runApp(const ThumbnailsApp());

class ThumbnailsApp extends StatelessWidget {
  const ThumbnailsApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RThemeModeProvider>(
          create: (context) => RThemeModeProvider(isDarkMode: false),
        ),
      ],
      child: ThemeProvider(
        initTheme: MyThemes.lightTheme,
        child: Builder(builder: (context) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home: const ThmbHomePage(title: 'Thumbnails YouTube'),
          );
        }),
      ),
    );
  }
}

class ThmbHomePage extends StatefulWidget {
  const ThmbHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ThmbHomePage> createState() => _ThmbHomePageState();
}

class _ThmbHomePageState extends State<ThmbHomePage> {
  final TextEditingController textEditingController = TextEditingController();
  List<String> resList = [];
  String videoId = "";
//
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<RThemeModeProvider>(context, listen: true);
    return ThemeSwitchingArea(
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              ThemeSwitcher(
                builder: (bcontext) => IconButton(
                  icon: const Icon(CupertinoIcons.moon_stars),
                  onPressed: () {
                    final theme = isDarkMode.isDarkMode ? MyThemes.lightTheme : MyThemes.darkTheme;

                    final isDarkModeChange = Provider.of<RThemeModeProvider>(
                      context,
                      listen: false,
                    );
                    isDarkModeChange.toggleThemeMode();
                    final switcher = ThemeSwitcher.of(bcontext);
                    switcher.changeTheme(theme: theme, isReversed: !isDarkMode.isDarkMode);
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                inputField(),
                if (videoId.isNotEmpty) imageBody(),
                if (resList.isNotEmpty) resolutionsChoix(),
                const ExampleDateRangePicker(),
              ],
            ),
          ),
          floatingActionButton: fab(),
        );
      }),
    );
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      onPressed: () async {
        await getClipBoardData();
      },
      tooltip: 'Increment',
      child: const Icon(Icons.paste),
    );
  }

  Padding inputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              consoleLog(videoId);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 8.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          suffixIconColor: Colors.green,
          prefixText: "https://",
        ),
      ),
    );
  }

  Center imageBody() {
    return Center(
      child: InteractiveViewer(
        child: Image(
          image: NetworkImage("https://i.ytimg.com/vi/$videoId/maxresdefault.jpg"),
          loadingBuilder: (BuildContext bcntxt, Widget widget, ImageChunkEvent? i) {
            return widget;
          },
          errorBuilder: (BuildContext btext, Object object, StackTrace? stackTrace) {
            return const Padding(
              padding: EdgeInsets.all(50),
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            );
          },
          frameBuilder: (BuildContext buildContext, Widget widget, int? op, bool rebuild) {
            return widget;
          },
        ),
      ),
    );
  }

  Builder resolutionsChoix() {
    return Builder(
      builder: (context) {
        var resList2 = resList[0];
        consoleLog(resList);
        consoleLog(resList2);
        var contains = resList.contains(resList2);
        consoleLog(contains);
        if (contains) {
          return DropdownButton(
            isExpanded: true,
            value: resList2,
            autofocus: true,
            borderRadius: BorderRadius.circular(20),
            elevation: 10,
            isDense: true,
            style: const TextStyle(fontSize: 24),
            /* selectedItemBuilder: (BuildContext _context) {
                    return [];
                  }, */
            dropdownColor: Colors.red,
            alignment: Alignment.center,
            items: resList
                .map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (String? value) {},
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<void> getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      var text = data.text;
      if (text != null) {
        var convertUrlTo = convertUrlToId(text);
        setState(() {
          if (convertUrlTo != null) {
            videoId = convertUrlTo;
          }
        });
        textEditingController.text = "youtube.com/watch?v=$videoId";
        List<String> resolutions = [
          "mqdefault",
          "hqdefault",
          "sddefault",
          "maxresdefault",
        ];
        List<ResStatusCode> res2 = await Future.wait(resolutions.map((e) => boolRes(e)));
        var list = res2.where((element) => element.statusCode == 200).toList();
        setState(() {
          resList = list.map((e) => resFrmEnum(e.resoluton)).toList();
        });
        consoleLog(list, color: 32);
      }
    }
  }

  Future<ResStatusCode> boolRes(resolution) async {
    var url = Uri.https('i.ytimg.com', '/vi/$videoId/$resolution.jpg');
    var response = await http.get(url);
    consoleLog(response.statusCode, color: 36);
    return ResStatusCode(statusCode: response.statusCode, resoluton: resFrmString(resolution));
  }
}
