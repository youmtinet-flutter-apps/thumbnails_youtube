import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thumbnail_youtube/utils/models.dart';
import 'package:thumbnail_youtube/utils/constants.dart';
import 'package:thumbnail_youtube/themes/colors.dart';
import 'package:thumbnail_youtube/utils/utils.dart';
import 'package:thumbnail_youtube/components/widgets.dart';

import 'components/historic.dart';

// import 'package:wakelock/wakelock.dart';
extension IntX on int {
  double get toRadian => this * pi / 180;
}

extension DoubleX on int {
  double get toRad => this * pi / 180;
}

class ThmbHomePage extends StatefulWidget {
  const ThmbHomePage({Key? key}) : super(key: key);

  @override
  State<ThmbHomePage> createState() => _ThmbHomePageState();
}

class _ThmbHomePageState extends State<ThmbHomePage> {
  // ResolutionList(extensionUrl: 'maxresdefault.jpg', view: '1280 x 720'),
  final TextEditingController textEditingController = TextEditingController();
  List<String> availableChoices = [
    '320 x 180',
    '480 x 360',
    '640 x 480',
    '1280 x 720',
  ];
  bool showFullscreenMonitor = true;
  String videoId = "";
  late String _resolution;
  final List<String> resolutions = [
    "mqdefault",
    "hqdefault",
    "sddefault",
    "maxresdefault",
  ];
//
  @override
  void initState() {
    super.initState();
    _resolution = availableChoices[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thumbnails YouTube'),
        actions: const [CuistomThemeSwitcher()],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            inputField(),
            if (videoId.isNotEmpty) imageBody(),
            if (availableChoices.isNotEmpty) resolutionsChoix(),
            GestureDetector(
              onTap: () => saveNetworkImage(_resolution, videoId),
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
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
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
              onPressed: () {
                Get.to(() => const HistoricPage());
              },
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
            FutureBuilder<List<String>>(
              future: getHistoric(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> historic = snapshot.data ?? [];
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: historic.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: .0,
                    ),
                    itemBuilder: (context, index) {
                      var vid = historic[historic.length - (index + 1)];
                      return Image(
                        image: NetworkImage(
                          "https://i.ytimg.com/vi/$vid/${RsolutionEnum.mqdefault.name}.jpg",
                        ),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator(
                    backgroundColor: Color(0xFF7A1C00),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: fab(),
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
            onTap: () async {
              await getImageFromUrl(textEditingController.text);
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
          helperText: "URI de video",
          hintText: 'Video url',
        ),
      ),
    );
  }

  Widget imageBody() {
    var res = resFrmReverse(_resolution).name;
    var url = "https://i.ytimg.com/vi/$videoId/$res.jpg";
    return Stack(
      children: [
        // SizedBox(height: 300, width: Get.width),
        Material(
          child: InkWell(
            onTap: () {
              setState(() {
                showFullscreenMonitor = !showFullscreenMonitor;
              });
            },
            child: Align(
              alignment: Alignment.center,
              child: MainImageview(url: url),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: showFullscreenMonitor
              ? Material(
                  child: InkWell(
                    onTap: () async {
                      await Get.generalDialog(
                        // transitionDuration: const Duration(seconds: 1),
                        transitionBuilder: (context, animation, secondaryAnimation, child) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Scaffold(
                            body: SizeTransition(
                              sizeFactor: animation,
                              child: Transform.rotate(
                                angle: 90.toRadian,
                                child: MainImageview(url: url),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Expanded(child: SizedBox()),
                          Icon(Icons.fullscreen),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ],
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
        items: availableChoices.map((e) {
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
        await getImageFromUrl(text);
      }
    }
  }

  Future<void> getImageFromUrl(String text) async {
    var convertUrlTo = convertUrlToId(text);
    if (convertUrlTo != null) {
      var resulutionsStatuses = await Future.wait(
        resolutions.map((e) => resolutionStatus(e, convertUrlTo)),
      );
      var available = resulutionsStatuses.where((e) => e.statusCode == 200).toList();
      if (available.isNotEmpty) {
        setState(() => videoId = convertUrlTo);
        textEditingController.text = "youtube.com/watch?v=$videoId";
        setState(() => availableChoices = available.map((e) => resFrmEnum(e.resoluton)).toList());
        await addToHistoric(videoId);
        await firestoreStatistics();
      } else {
        setState(() => videoId = '');
        textEditingController.text = '';
        setState(() => availableChoices =
            resolutions.map((e) => resFrmString(e)).map((e) => resFrmEnum(e)).toList());
      }
    } else {
      Get.showSnackbar(const GetSnackBar(message: 'URI non valide'));
    }
  }

  Future<void> firestoreStatistics() async {
    final result =
        await firebaseFirestore.collection('statistics').where("videoId", isEqualTo: videoId).get();
    if (result.docs.isNotEmpty) {
      for (var e in result.docs) {
        consoleLog(e.data(), color: 34);
      }
    }
    final collection = firebaseFirestore.collection('statistics');
    collection.add({
      "lastuse": Timestamp((DateTime.now().millisecondsSinceEpoch / 1000).floor(), 0),
      "videoId": videoId,
      "downloads": 0,
      "views": 1,
      "likes": 0,
    });
  }
}

Future<ResStatusCode> resolutionStatus(resolution, String videoId) async {
  var url = Uri.https('i.ytimg.com', '/vi/$videoId/$resolution.jpg');
  var response = await http.get(url);
  return ResStatusCode(statusCode: response.statusCode, resoluton: resFrmString(resolution));
}
