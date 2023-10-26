import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils.dart';

class AppProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late List<VideoThumbnailMetataData> _firebaseHistory;
  List<VideoThumbnailMetataData> get firebaseHistory => _firebaseHistory;
  List<RsolutionEnum> _availableChoices = RsolutionEnum.values;
  List<RsolutionEnum> get availableChoices => _availableChoices;

  void setAvailableChoices(List<RsolutionEnum> value) {
    _availableChoices = value;
    notifyListeners();
  }

  String _videoId = "";
  String get videoId => _videoId;
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

  Future<void> addLike(VideoThumbnailMetataData value) async {
    value.likes++;
    notifyListeners();
  }

  void addView(VideoThumbnailMetataData value) {
    value.views++;
    notifyListeners();
  }

  void addDownload(String value) {
    for (var histor in firebaseHistory) {
      if (histor.videoId != value) continue;
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
  }
}
