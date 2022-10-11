import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/themes/colors.dart';
import 'package:thumbnail_youtube/themes/dark_theme.dart';
import 'package:thumbnail_youtube/providers.dart';
import 'package:thumbnail_youtube/utils.dart';
// import 'package:wakelock/wakelock.dart';
import 'themes/light_theme.dart';

class ThmbHomePage extends StatefulWidget {
  const ThmbHomePage({Key? key}) : super(key: key);

  @override
  State<ThmbHomePage> createState() => _ThmbHomePageState();
}

class _ThmbHomePageState extends State<ThmbHomePage> {
  final TextEditingController textEditingController = TextEditingController();
  List<String> resList = [
    '320 x 180',
    '480 x 360',
    '640 x 480',
    // ResolutionList(extensionUrl: 'maxresdefault.jpg', view: '1280 x 720'),
    '1280 x 720',
  ];
  String videoId = "";
  late String _resolution;
//
  @override
  void initState() {
    super.initState();
    _resolution = resList[0];
  }

  @override
  Widget build(BuildContext context) {
    /* var minSdk = android.adaptiveForegroundIcons.map((e) => e.directoryName);
    */
    final isDarkMode = Provider.of<RThemeModeProvider>(context, listen: true).isDarkMode;
    return ThemeSwitchingArea(
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Thumbnails YouTube'),
            actions: [
              ThemeSwitcher(
                builder: (bcontext) => IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: isDarkMode
                        ? const Icon(CupertinoIcons.moon_stars)
                        : const Icon(CupertinoIcons.sun_haze),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: RotationTransition(
                          turns: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                  onPressed: () async {
                    final theme = isDarkMode ? lightTheme : darkTheme;

                    final isDarkModeChange = Provider.of<RThemeModeProvider>(
                      context,
                      listen: false,
                    );
                    await savePreferences(
                      isDarkMode ? Brightness.light : Brightness.dark,
                    );
                    isDarkModeChange.toggleThemeMode();
                    final switcher = ThemeSwitcher.of(bcontext);
                    switcher.changeTheme(theme: theme, isReversed: isDarkMode);
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Material(
              child: InkWell(
                child: Column(
                  children: [
                    inputField(),
                    if (videoId.isNotEmpty) imageBody(),
                    if (resList.isNotEmpty) resolutionsChoix(),
                    GestureDetector(
                      onTap: _saveNetworkImage,
                      child: Container(
                        width: Get.width * 0.75,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              'Download',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Icon(Icons.download),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryColor.withBlue(primaryColor.blue + 50),
                              primaryColor,
                            ],
                          ),
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.history_toggle_off),
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      itemBuilder: (context, index) {
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: fab(),
        );
      }),
    );
  }

  Widget fab() {
    return FloatingActionButton(
      onPressed: () async {
        await getClipBoardData();
      },
      tooltip: 'Increment',
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      child: Container(
        width: 60,
        height: 60,
        child: const Icon(Icons.paste),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              primaryColor,
              primaryColor.withBlue(primaryColor.blue + 50),
            ],
            stops: const [0.65, 0.95],
          ),
        ),
      ),
    );
  }

  Widget inputField() {
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
              margin: const EdgeInsets.only(right: 4.0),
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
          prefixText: "https://",
          hintText: 'Video url',
        ),
      ),
    );
  }

  Widget imageBody() {
    var res = resFrmReverse(_resolution).name;
    consoleLog(res);
    var url = "https://i.ytimg.com/vi/$videoId/$res.jpg";
    return Center(
      child: InteractiveViewer(
        child: Image(
          image: NetworkImage(url),
          loadingBuilder: (BuildContext bcntxt, Widget widget, ImageChunkEvent? i) {
            return widget;
          },
          errorBuilder: (BuildContext btext, Object object, StackTrace? stackTrace) {
            return const ErrorWidget();
          },
          frameBuilder: (BuildContext buildContext, Widget widget, int? op, bool rebuild) {
            return widget;
          },
        ),
      ),
    );
  }

  Widget resolutionsChoix() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        isExpanded: true,
        value: _resolution,
        autofocus: true,
        elevation: 10,
        /* selectedItemBuilder: (BuildContext _context) {
            return [];
          }, */
        decoration: const InputDecoration(fillColor: Colors.black),
        borderRadius: BorderRadius.circular(20),
        icon: const Icon(Icons.downloading_sharp),
        alignment: Alignment.center,
        items: resList.map((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _resolution = value ?? _resolution;
          });
        },
      ),
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

  void _saveNetworkImage() async {
    var res = resFrmReverse(_resolution).name;
    String path = "https://i.ytimg.com/vi/$videoId/$res.jpg";
    var afterSave = await GallerySaver.saveImage(path, toDcim: false, albumName: 'VideoThumnails');
    if (afterSave != null) {
      if (afterSave) {
        Get.showSnackbar(
          GetSnackBar(
            messageText: Row(
              children: [
                const Expanded(
                  child: Text("Image downloaded successfully!"),
                ),
                Container(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.download_done),
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  Future<ResStatusCode> boolRes(resolution) async {
    var url = Uri.https('i.ytimg.com', '/vi/$videoId/$resolution.jpg');
    var response = await http.get(url);
    consoleLog('${response.statusCode}', color: 35);
    return ResStatusCode(statusCode: response.statusCode, resoluton: resFrmString(resolution));
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    this.message,
  }) : super(key: key);
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          if (message != null) Text(message ?? '')
        ],
      ),
    );
  }
}
