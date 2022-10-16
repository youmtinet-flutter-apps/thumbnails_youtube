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

enum RsolutionEnum {
  mqdefault,
  hqdefault,
  sddefault,
  maxresdefault,
}

enum PreferencesKeys {
  theme,
  historic,
}
