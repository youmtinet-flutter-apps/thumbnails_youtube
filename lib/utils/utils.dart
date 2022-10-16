import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thumbnail_youtube/utils/models.dart';

import '../themes/colors.dart';

Future<void> klearHistoric() async {
  var preferences = await SharedPreferences.getInstance();
  preferences.remove(PreferencesKeys.historic.name);
  return;
}

Future<List<String>> getHistoric() async {
  var preferences = await SharedPreferences.getInstance();
  List<String> prev = preferences.getStringList(PreferencesKeys.historic.name) ?? [];
  return prev;
}

Future<String> getPreferences() async {
  var preferences = await SharedPreferences.getInstance();
  var s = preferences.getString(PreferencesKeys.theme.name);
  return s ?? Brightness.light.name;
}

Future<void> savePreferences(Brightness brightness) async {
  var preferences = await SharedPreferences.getInstance();
  preferences.setString(PreferencesKeys.theme.name, brightness.name);
}

Future<void> addToHistoric(String vid) async {
  var preferences = await SharedPreferences.getInstance();
  List<String> prev = await getHistoric();
  if (!prev.contains(vid)) {
    preferences.setStringList(PreferencesKeys.historic.name, [...prev, vid]);
  }
}

void consoleLog(text, {int color = 37}) => debugPrint('\x1B[${color}m $text\x1B[0m');

void saveNetworkImage(String _resolution, String videoId) async {
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

String resFrmEnum(RsolutionEnum res) {
  switch (res) {
    case RsolutionEnum.mqdefault:
      return "320 x 180";
    case RsolutionEnum.hqdefault:
      return "480 x 360";
    case RsolutionEnum.sddefault:
      return "640 x 480";
    case RsolutionEnum.maxresdefault:
      return "1280 x 720";
    default:
      return "320 x 180";
  }
}

RsolutionEnum resFrmReverse(String res) {
  switch (res) {
    case "320 x 180":
      return RsolutionEnum.mqdefault;
    case "480 x 360":
      return RsolutionEnum.hqdefault;
    case "640 x 480":
      return RsolutionEnum.sddefault;
    case "1280 x 720":
      return RsolutionEnum.maxresdefault;
    default:
      return RsolutionEnum.mqdefault;
  }
}

RsolutionEnum resFrmString(String res) => RsolutionEnum.values.firstWhere((e) => e.name == res);

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (url.isEmpty) return null;
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  var list = [
    RegExp(r"^youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ];
  for (var exp in list) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}
