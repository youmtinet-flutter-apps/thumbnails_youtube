import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class AppProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _loading = false;
  String _videoId = "";
  List<RsolutionEnum> _availableChoices = RsolutionEnum.values;
  RsolutionEnum _resolution = RsolutionEnum.mqdefault;
  late DateTime _datetimeAds;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController resolutionSelectionController = TextEditingController();

  AppProvider({required DateTime datetimeAds}) {
    _datetimeAds = datetimeAds;
  }

  String get videoId => _videoId;
  List<RsolutionEnum> get availableChoices => _availableChoices;
  RsolutionEnum get resolution => _resolution;
  bool get isAdsTime => _datetimeAds.isBefore(DateTime.now().subtract(Duration(minutes: 10)));
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String thumbnail({String? videoId, bool maxRes = false, bool mainView = true}) {
    RsolutionEnum rsolutionEnum = (maxRes ? _availableChoices.last : (mainView ? _resolution : RsolutionEnum.mqdefault));
    String thum = "https://i.ytimg.com/vi/${videoId ?? _videoId}/${rsolutionEnum.name}.jpg";
    return thum;
  }

  void setResolution(RsolutionEnum? value) {
    _resolution = value ?? _resolution;
    resolutionSelectionController.text = _resolution.getResourceFromEnum();
    notifyListeners();
  }

  void setAvailableChoices(List<RsolutionEnum> value) {
    _availableChoices = value;
    notifyListeners();
  }

  void updateTextEditor() {
    textEditingController.text = "youtube.com/watch?v=$_videoId";
    notifyListeners();
  }

  void setvideoId(String value) {
    _videoId = value;
    updateTextEditor();
    notifyListeners();
  }

  void setvideoIdFromUrl(BuildContext context, String url) {
    String? idFROMurl = convertUrlToId(url);
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
