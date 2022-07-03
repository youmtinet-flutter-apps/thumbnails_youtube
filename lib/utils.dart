import 'package:flutter/foundation.dart';

class ResStatusCode {
  resolutionEnum resoluton;
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

enum resolutionEnum {
  mqdefault,
  hqdefault,
  sddefault,
  maxresdefault,
}

void consoleLog(text, {int color = 37}) {
  debugPrint('\x1B[${color}m $text\x1B[0m');
}

String resFrmEnum(resolutionEnum res) {
  switch (res) {
    case resolutionEnum.mqdefault:
      return "320 x 180";
    case resolutionEnum.hqdefault:
      return "480 x 360";
    case resolutionEnum.sddefault:
      return "640 x 480";
    case resolutionEnum.maxresdefault:
      return "1280 x 720";
    default:
      return "320 x 180";
  }
}

resolutionEnum resFrmString(String res) {
  switch (res) {
    case "mqdefault":
      return resolutionEnum.mqdefault;
    case "hqdefault":
      return resolutionEnum.hqdefault;
    case "sddefault":
      return resolutionEnum.sddefault;
    case "maxresdefault":
      return resolutionEnum.maxresdefault;
    default:
      return resolutionEnum.mqdefault;
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
