import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7566702396165026/2154250694';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAd2UnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7566702396165026/5374476256';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7566702396165026/9841169020';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7566702396165026/8144943979';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
