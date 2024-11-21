import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class AppProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _videoId = "";
  List<RsolutionEnum> _availableChoices = RsolutionEnum.values;
  RsolutionEnum _resolution = RsolutionEnum.mqdefault;
  late DateTime _datetimeAds;
  final TextEditingController textEditingController = TextEditingController();

  AppProvider({required DateTime datetimeAds}) {
    _datetimeAds = datetimeAds;
  }

  String get videoId => _videoId;
  List<RsolutionEnum> get availableChoices => _availableChoices;
  RsolutionEnum get resolution => _resolution;
  bool get isAdsTime => _datetimeAds.isBefore(
        DateTime.now().subtract(
          Duration(minutes: 5),
        ),
      );

  String thumbnail({String? videoId, bool maxRes = false, bool mainView = true}) {
    var rsolutionEnum = (maxRes ? _availableChoices.last : (mainView ? _resolution : RsolutionEnum.mqdefault));
    var thum = "https://i.ytimg.com/vi/${videoId ?? _videoId}/${rsolutionEnum.name}.jpg";
    return thum;
  }

  void setResolution(RsolutionEnum? value) {
    _resolution = value ?? _resolution;
    notifyListeners();
  }

  void setAvailableChoices(List<RsolutionEnum> value) {
    _availableChoices = value;
    notifyListeners();
  }

  void setvideoId(String value) {
    _videoId = value;
    notifyListeners();
  }

  void setvideoIdFromUrl(BuildContext context, String url) {
    var idFROMurl = convertUrlToId(url);
    if (idFROMurl == null) {
      appSnackbar(context, 'Infos', "URI non valide");
    } else {
      _videoId = idFROMurl;
    }
    notifyListeners();
  }

  void addFromLocal(VideoThumbnailMetataData value) {
    value.isLocal = true;
    notifyListeners();
  }

  Future<void> updateAdsTime() async {
    _datetimeAds = DateTime.now();
    await saveAdsDateTime();
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('textEditingController', textEditingController));
    properties.add(IterableProperty<RsolutionEnum>('_availableChoices', _availableChoices));
    properties.add(EnumProperty<RsolutionEnum>('_resolution', _resolution));
    properties.add(DiagnosticsProperty<DateTime>('_datetimeAds', _datetimeAds));
    properties.add(StringProperty('_videoId', _videoId));
  }
}
