import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class AppProvider with ChangeNotifier, DiagnosticableTreeMixin {
  List<RsolutionEnum> _availableChoices = RsolutionEnum.values;
  List<RsolutionEnum> get availableChoices => _availableChoices;
  RsolutionEnum _resolution = RsolutionEnum.mqdefault;
  RsolutionEnum get resolution => _resolution;

  late DateTime _datetimereward;
  bool get isRewardTime => _datetimereward.isBefore(
        DateTime.now().subtract(
          Duration(minutes: 10),
        ),
      );

  void updateRewardTime() {
    _datetimereward = DateTime.now();
    notifyListeners();
  }

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
    var rsolutionEnum = (maxRes ? _availableChoices.last : (mainView ? _resolution : RsolutionEnum.mqdefault));
    var thum = "https://i.ytimg.com/vi/${videoId ?? _videoId}/${rsolutionEnum.name}.jpg";
    return thum;
  }

  final TextEditingController textEditingController = TextEditingController();

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

  AppProvider({required DateTime datetimereward}) {
    _datetimereward = datetimereward;
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

  void addFromLocal(VideoThumbnailMetataData value) {
    value.isLocal = true;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('textEditingController', textEditingController));
    properties.add(IterableProperty<RsolutionEnum>('_availableChoices', _availableChoices));
    properties.add(EnumProperty<RsolutionEnum>('_resolution', _resolution));
  }
}
