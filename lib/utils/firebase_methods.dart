import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'dart:developer' as developer;

Future<void> firestoreStatistics(Incremente incremente, String videoId, BuildContext context) async {
  final collection = firebaseFirestore.collection('statistics');

  final data = await collection.where("videoId", isEqualTo: videoId).get();

  var dateTime = DateTime.now();
  var millisecondsSinceEpoch = dateTime.millisecondsSinceEpoch;
  var floor = (millisecondsSinceEpoch / 1000).floor();
  var timestamp = Timestamp(floor, 0);
  if (data.docs.isEmpty) {
    var docToAdd = VideoThumbnailMetataData(
      lastuse: timestamp,
      videoId: videoId,
      downloads: 0,
      likes: 0,
      views: 1,
    );

    context.read<AppProvider>().add(docToAdd);
    await collection.add(docToAdd.toMap());
  } else {
    var docFound = data.docs.first;
    developer.log('docFound.id = ${docFound.id}');
    var found = VideoThumbnailMetataData.fromJson(docFound.data());
    docFound.reference.update(VideoThumbnailMetataData(
      videoId: found.videoId,
      lastuse: timestamp,
      downloads: incremente == Incremente.downloads ? found.downloads + 1 : found.downloads,
      views: incremente == Incremente.views ? found.views + 1 : found.views,
      likes: incremente == Incremente.likes ? found.likes + 1 : found.likes,
    ).toMap());
  }
}
