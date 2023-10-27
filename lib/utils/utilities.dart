import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thumbnail_youtube/lib.dart';

Future<String> getThemeModePrefs() async {
  var preferences = await SharedPreferences.getInstance();
  var s = preferences.getString(PreferencesKeys.theme.name);
  return s ?? Brightness.light.name;
}

Future<void> saveThemeModePrefs(Brightness brightness) async {
  var preferences = await SharedPreferences.getInstance();
  preferences.setString(PreferencesKeys.theme.name, brightness.name);
}

Future<List<String>> getLocalHistoric() async {
  var preferences = await SharedPreferences.getInstance();
  List<String> prev = preferences.getStringList(PreferencesKeys.historic.name) ?? [];
  return prev;
}

Future<void> klearLocalHistoric() async {
  var preferences = await SharedPreferences.getInstance();
  preferences.remove(PreferencesKeys.historic.name);
  return;
}

Future<void> addToHistoric(String vid) async {
  var preferences = await SharedPreferences.getInstance();
  List<String> prev = await getLocalHistoric();
  if (!prev.contains(vid)) {
    preferences.setStringList(PreferencesKeys.historic.name, [...prev, vid]);
  }
}

Future<ResStatusCode> resolutionStatus(RsolutionEnum resolution, String videoId) async {
  var url = Uri.https('i.ytimg.com', '/vi/$videoId/${resolution.name}.jpg');
  var response = await http.get(url);
  return ResStatusCode(statusCode: response.statusCode, resoluton: resolution);
}

Future<ResStatusCodeVideo> resolu(
  RsolutionEnum resolution,
  VideoThumbnailMetataData video,
) async {
  var url = Uri.https('i.ytimg.com', '/vi/${video.videoId}/${resolution.name}.jpg');
  var response = await http.get(url);
  return ResStatusCodeVideo(statusCode: response.statusCode, resoluton: resolution, video: video);
}

Future<void> getImageFromUrl(String text, BuildContext context) async {
  context.read<AppProvider>().setvideoIdFromUrl(text);
  var videoId = context.read<AppProvider>().videoId;
  List<ResStatusCode> resulutionsStatuses = await Future.wait(
    RsolutionEnum.values.map((e) => resolutionStatus(e, videoId)),
  );
  var available = resulutionsStatuses.where((e) => e.statusCode == 200).toList();
  var textEditingController = context.watch<AppProvider>().textEditingController;
  if (available.isNotEmpty) {
    textEditingController.text = "youtube.com/watch?v=$videoId";
    context.read<AppProvider>().setAvailableChoices(available.map((e) => e.resoluton).toList());
    await addToHistoric(videoId);
    await firestoreStatistics(Incremente.views, videoId, context);
  } else {
    context.read<AppProvider>().setvideoId("");
    textEditingController.text = '';
    var map = RsolutionEnum.values.map((e) => e);
    context.read<AppProvider>().setAvailableChoices(map.toList());
  }
}

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (url.isEmpty) return null;
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  var list = [
    RegExp(r"^youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
  ];
  for (var exp in list) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

void appSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    duration: const Duration(seconds: 10),
    forwardAnimationCurve: Curves.bounceInOut,
    reverseAnimationCurve: Curves.bounceOut,
    snackStyle: SnackStyle.FLOATING,
    showProgressIndicator: false,
    snackbarStatus: (status) {
      dev.log(status.toString());
    },
    padding: const EdgeInsets.all(30.0),
    margin: const EdgeInsets.all(30.0),
    boxShadows: [
      BoxShadow(
        blurRadius: 30,
        blurStyle: BlurStyle.outer,
        color: Get.theme.primaryColor,
      ),
    ],
    animationDuration: const Duration(seconds: 2),
    colorText: Get.theme.primaryColor,
    /* mainButton: TextButton(
      onPressed: () {
        controller.close();
      },
      child: const Text('Dismiss'),
    ), */
    icon: Container(
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.download_done),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.theme.primaryColor,
      ),
    ),
    barBlur: 0,
  );
}

/* Future<void> _folding(CollectionReference<Map<String, dynamic>> collection) async {
  final data = await collection.get();
  var metadata = data.docs.map((e) => VideoThumbnailMetataData.fromJson(e.data())).toList();
  var foldmetadata = metadata.fold<List<VideoThumbnailMetataData>>([], (previousValue, element) {
    if (!previousValue.map((e) => e.videoId).contains(element.videoId)) {
      previousValue.add(element);
    } else {
      developer.log('element = $element');
    }
    return previousValue;
  });
  developer.log("Before ${metadata.length}", level: 1);
  developer.log("After ${foldmetadata.length}", level: 1);
} */
