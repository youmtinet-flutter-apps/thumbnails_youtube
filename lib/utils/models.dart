import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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

class ResStatusCodeVideo {
  RsolutionEnum resoluton;
  int statusCode;
  VideoThumbnailMetataData video;
  ResStatusCodeVideo({
    required this.resoluton,
    required this.statusCode,
    required this.video,
  });

  @override
  String toString() {
    return '$resoluton $statusCode';
  }
}

class VideoThumbnailMetataData {
  late Timestamp lastuse;
  late int downloads;
  late String videoId;
  late int views;
  late int likes;
  bool isLocal = false;
  VideoThumbnailMetataData({
    required this.videoId,
    required this.lastuse,
    required this.downloads,
    required this.views,
    required this.likes,
    this.isLocal = false,
  });
  VideoThumbnailMetataData.fromJson(Map<String, dynamic> data) {
    lastuse = data["lastuse"];
    downloads = data["downloads"];
    videoId = data["videoId"];
    views = data["views"];
    likes = data["likes"];
  }
  VideoThumbnailMetataData copyWith(List<String> vId) {
    return VideoThumbnailMetataData(
      lastuse: lastuse,
      downloads: downloads,
      videoId: videoId,
      views: views,
      likes: likes,
      isLocal: vId.contains(videoId),
    );
  }

  Map<String, dynamic> toMap() => ({
        "lastuse": lastuse,
        "downloads": downloads,
        "videoId": videoId,
        "views": views,
        "likes": likes,
      });
  @override
  String toString() {
    return "VideoThumbnailMetataData(lastuse = $lastuse, downloads = $downloads, videoId = $videoId, views = $views, likes = $likes)";
  }

  @override
  bool operator ==(Object other) {
    return other is VideoThumbnailMetataData && other.runtimeType == runtimeType && other.lastuse == lastuse && other.downloads == downloads && other.videoId == videoId && other.views == views && other.likes == likes;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      lastuse,
      downloads,
      videoId,
      views,
      likes,
    );
  }
}

extension IntX on int {
  double get toRadian => this * pi / 180;
}

extension DoubleX on int {
  double get toRad => this * pi / 180;
}

extension EnumX on RsolutionEnum {
  String resFrmEnum() {
    switch (this) {
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
}

RsolutionEnum resFrmStr(String? resolu) {
  switch (resolu) {
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

enum PreferencesKeys {
  theme,
  historic,
  adsDateTime,
  videoThumnails,
}

enum Incremente { views, likes, downloads }

enum RsolutionEnum {
  mqdefault,
  hqdefault,
  sddefault,
  maxresdefault,
}
