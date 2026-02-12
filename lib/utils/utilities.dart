import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thumbnail_youtube/lib.dart';

Future<DateTime> getAdsDateTime() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? s = preferences.getString(PreferencesKeys.adsDateTime.name);
  DateTime dateTime = DateTime.now().subtract(Duration(minutes: 11));
  return DateTime.parse(s ?? dateTime.toString());
}

Future<void> saveAdsDateTime() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString(PreferencesKeys.adsDateTime.name, DateTime.now().toString());
}

Future<List<String>> getLocalHistoric() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String> prev = preferences.getStringList(PreferencesKeys.historic.name) ?? <String>[];
  return prev;
}

Future<void> klearLocalHistoric() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove(PreferencesKeys.historic.name);
  return;
}

Future<void> addToHistoric(String vid) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String> prev = await getLocalHistoric();
  if (!prev.contains(vid)) {
    preferences.setStringList(PreferencesKeys.historic.name, <String>[...prev, vid]);
  }
}

Future<ResStatusCode> resolutionStatus(RsolutionEnum resolution, String videoId) async {
  Uri url = Uri.https('i.ytimg.com', '/vi/$videoId/${resolution.name}.jpg');
  http.Response response = await http.get(url);
  return ResStatusCode(statusCode: response.statusCode, resoluton: resolution);
}

Future<void> getImageFromUrl(BuildContext context, String text) async {
  context.read<AppProvider>().setvideoIdFromUrl(context, text);
  String videoId = context.read<AppProvider>().videoId;
  List<ResStatusCode> resulutionsStatuses = await Future.wait(RsolutionEnum.values.map((RsolutionEnum e) => resolutionStatus(e, videoId)));
  List<ResStatusCode> available = resulutionsStatuses.where((ResStatusCode e) => e.statusCode == 200).toList();
  if (available.isNotEmpty) {
    context.read<AppProvider>().updateTextEditor();
    context.read<AppProvider>().setAvailableChoices(available.map((ResStatusCode e) => e.resoluton).toList());
    await addToHistoric(videoId);
    await firestoreStatistics(Incremente.views, videoId, context);
  } else {
    context.read<AppProvider>().setvideoId("");
    context.read<AppProvider>().updateTextEditor();
    Iterable<RsolutionEnum> map = RsolutionEnum.values.map((RsolutionEnum e) => e);
    context.read<AppProvider>().setAvailableChoices(map.toList());
  }
}

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (url.isEmpty) return null;
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  List<RegExp> list = <RegExp>[RegExp(r"(?:https:\/\/)?(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"), RegExp(r"(?:https:\/\/)?youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")];
  for (RegExp exp in list) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

void appSnackbar(BuildContext context, String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    duration: Duration(seconds: 10),
    forwardAnimationCurve: Curves.bounceInOut,
    reverseAnimationCurve: Curves.bounceOut,
    snackStyle: SnackStyle.FLOATING,
    showProgressIndicator: false,
    snackbarStatus: (SnackbarStatus? status) {},
    padding: EdgeInsets.all(30.0),
    margin: EdgeInsets.all(30.0),
    boxShadows: <BoxShadow>[BoxShadow(blurRadius: 30, blurStyle: BlurStyle.outer, color: Theme.of(context).colorScheme.primary)],
    animationDuration: Duration(seconds: 2),
    colorText: Theme.of(context).colorScheme.primary,
    /* mainButton: TextButton(
      onPressed: () {
        controller.close();
      },
      child: Text('Dismiss'),
    ), */
    icon: Container(
      child: Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.download_done)),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary),
    ),
    barBlur: 0,
  );
}

extension LISTWX<T> on Iterable<T> {
  Iterable<E> mapFolded<E>(E Function(int index, T current, T next) convert) sync* {
    for (int index = 0; index < length - 1; index++) {
      yield convert(index, elementAt(index), elementAt(index + 1));
    }
  }

  Iterable<E> mapFoldedGeneralized<E>(E Function(int index, List<T> items) convert, int groups, int couverage) sync* {
    // groups > 1 && couverage >= 0 && couverage < groups;
    int cover = min(couverage, groups - 1);
    int ceiling = length - cover;
    for (int index = 0; index < ceiling; index += groups - cover) {
      yield convert(index, toList().sublist(index, min(index + groups, length)));
    }
  }

  Iterable<W> whereMapCumuled<E, W>({required E Function(int index, T current, T next) foldFunction, required E Function(E a, E b) reduce, required bool Function(int index, E cumul) test, required W Function(int index, T element) convert}) sync* {
    for (int index = 1; index < length; index++) {
      List<T> ftt = toList().sublist(0, index + 1);
      List<E> mpf = ftt.mapFolded<E>(foldFunction).toList();
      E f = mpf.reduce(reduce);
      if (test(index, f)) yield convert(index, elementAt(index));
    }
  }

  W? firstWhereMapCumuled<E, W>({required E Function(int index, T current, T next) foldFunction, required bool Function(int index, E cumul) test, required E Function(E a, E b) reduce, required W Function(int index, T element) convert}) {
    Iterable<W> where = whereMapCumuled(foldFunction: foldFunction, test: test, convert: convert, reduce: reduce);
    return where.firstOrNull;
  }
}

/* Future<void> _folding(CollectionReference<Map<String, dynamic>> collection) async {
  final data = await collection.get();
  var metadata = data.docs.map((e) => VideoThumbnailMetataData.fromJson(e.data())).toList();
  var foldmetadata = metadata.fold<List<VideoThumbnailMetataData>>([], (previousValue, element) {
    if (!previousValue.map((e) => e.videoId).contains(element.videoId)) {
      previousValue.add(element);
    } else {
      developer.log ('element = $element');
    }
    return previousValue;
  });
  developer.log ("Before ${metadata.length}", level: 1);
  developer.log ("After ${foldmetadata.length}", level: 1);
} */
