import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResolutionList {
  String extensionUrl;
  String view;
  ResolutionList({required this.extensionUrl, required this.view});
}

class ResStatusCode {
  RsolutionEnum resoluton;
  int statusCode;
  ResStatusCode({
    required this.resoluton,
    required this.statusCode,
  });

  @override
  String toString() {
    return '$resoluton $statusCode';
  }
}

enum RsolutionEnum {
  mqdefault,
  hqdefault,
  sddefault,
  maxresdefault,
}

enum PreferencesKeys {
  theme,
  historic,
}

void consoleLog(text, {int color = 37}) {
  debugPrint('\x1B[${color}m $text\x1B[0m');
}

Future<void> savePreferences(Brightness brightness) async {
  var preferences = await SharedPreferences.getInstance();
  preferences.setString(PreferencesKeys.theme.name, brightness.name);
}

Future<void> addToHistoric(String vid) async {
  var preferences = await SharedPreferences.getInstance();
  List<String> prev = await getHistoric();
  preferences.setStringList(PreferencesKeys.historic.name, [...prev, vid]);
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

RsolutionEnum resFrmString(String res) {
  switch (res) {
    case "mqdefault":
      return RsolutionEnum.mqdefault;
    case "hqdefault":
      return RsolutionEnum.hqdefault;
    case "sddefault":
      return RsolutionEnum.sddefault;
    case "maxresdefault":
      return RsolutionEnum.maxresdefault;
    default:
      return RsolutionEnum.mqdefault;
  }
}

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  assert(url.isNotEmpty, 'Url cannot be empty');
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}
