import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thumbnail_youtube/lib.dart';

Future<void> firestoreStatistics(Incremente incremente, String videoId, BuildContext context) async {
  final CollectionReference<Map<String, dynamic>> collection = firebaseFirestore.collection('statistics');

  final QuerySnapshot<Map<String, dynamic>> data = await collection.where("videoId", isEqualTo: videoId).get();

  DateTime dateTime = DateTime.now();
  int millisecondsSinceEpoch = dateTime.millisecondsSinceEpoch;
  int floor = (millisecondsSinceEpoch / 1000).floor();
  Timestamp timestamp = Timestamp(floor, 0);
  if (data.docs.isEmpty) {
    VideoThumbnailMetataData docToAdd = VideoThumbnailMetataData(lastuse: timestamp, videoId: videoId, downloads: 0, likes: 0, views: 1);

    await collection.add(docToAdd.toMap());
  } else {
    QueryDocumentSnapshot<Map<String, dynamic>> docFound = data.docs.first;
    VideoThumbnailMetataData found = VideoThumbnailMetataData.fromJson(docFound.data());
    docFound.reference.update(VideoThumbnailMetataData(videoId: found.videoId, lastuse: timestamp, downloads: incremente == Incremente.downloads ? found.downloads + 1 : found.downloads, views: incremente == Incremente.views ? found.views + 1 : found.views, likes: incremente == Incremente.likes ? found.likes + 1 : found.likes).toMap());
  }
}
