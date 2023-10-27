import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils.dart';

class AppProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late List<VideoThumbnailMetataData> _firebaseHistory;
  List<VideoThumbnailMetataData> get firebaseHistory => _firebaseHistory
    ..sort(
      (a, b) => a.views - b.views,
    );
  List<RsolutionEnum> _availableChoices = RsolutionEnum.values;
  List<RsolutionEnum> get availableChoices => _availableChoices;
  RsolutionEnum _resolution = RsolutionEnum.mqdefault;
  RsolutionEnum get resolution => _resolution;

  void setResolution(RsolutionEnum? value) {
    _resolution = value ?? _resolution;
    notifyListeners();
  }

  void setAvailableChoices(List<RsolutionEnum> value) {
    _availableChoices = value;
    notifyListeners();
  }

  String _videoId = "";
  String get videoId => _videoId;
  String thumbnail({String? videoId, bool maxRes = false, bool mainView = true}) {
    var thum = "https://i.ytimg.com/vi/${videoId ?? _videoId}/${(maxRes ? _availableChoices.last : (mainView ? _resolution : RsolutionEnum.mqdefault)).name}.jpg";
    return thum;
  }

  final TextEditingController textEditingController = TextEditingController();

  void setvideoId(String value) {
    _videoId = value;
    notifyListeners();
  }

  void setvideoIdFromUrl(String url) {
    var idFROMurl = convertUrlToId(url);
    if (idFROMurl == null) {
      appSnackbar('Infos', "URI non valide");
    } else {
      _videoId = idFROMurl;
    }
    notifyListeners();
  }

  AppProvider({
    required List<String> history,
    required List<VideoThumbnailMetataData> firebaseHistory,
  }) {
    _firebaseHistory = firebaseHistory.map((e) => e.copyWith(history)).toList();
  }

  void add(VideoThumbnailMetataData value) {
    VideoThumbnailMetataData? exists = _firebaseHistory.firstWhereOrNull((e) => e == value);
    if (exists != null) return;
    _firebaseHistory.add(value);
    notifyListeners();
  }

  Future<void> addLike(VideoThumbnailMetataData value, BuildContext context) async {
    await firestoreStatistics(Incremente.likes, value.videoId, context);
    value.likes++;
    notifyListeners();
  }

  Future<void> addView(VideoThumbnailMetataData value, BuildContext context) async {
    await firestoreStatistics(Incremente.views, value.videoId, context);
    value.views++;
    notifyListeners();
  }

  Future<void> addDownload(BuildContext context) async {
    await firestoreStatistics(Incremente.downloads, _videoId, context);
    for (var histor in firebaseHistory) {
      if (histor.videoId != _videoId) continue;
      histor.downloads++;
      break;
    }
    notifyListeners();
  }

  void addFromLocal(VideoThumbnailMetataData value) {
    value.isLocal = true;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<VideoThumbnailMetataData>('_firebaseHistory', _firebaseHistory));
    properties.add(DiagnosticsProperty<TextEditingController>('textEditingController', textEditingController));
    properties.add(IterableProperty<RsolutionEnum>('_availableChoices', _availableChoices));
    properties.add(EnumProperty<RsolutionEnum>('_resolution', _resolution));
  }
}
