// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Thumbnails YouTube';

  @override
  String get videoLoadError => 'An error occurred while loading the video';

  @override
  String get errorTitle => 'Error';

  @override
  String get infoTitle => 'Info';

  @override
  String get invalidUrl => 'Invalid URL';

  @override
  String get pasteYoutubeUrlHint => 'Paste a YouTube URL';

  @override
  String get openFullQuality => 'Open full quality';

  @override
  String get resolutionLabel => 'Resolution';

  @override
  String get downloadSuccess => 'Image downloaded successfully!';

  @override
  String get watchOnYoutube => 'Watch on YouTube';

  @override
  String get youtubeOpenFailed => 'Could not open YouTube';

  @override
  String get adsDialogTitle => 'Advertisement';

  @override
  String get adsDialogMessage =>
      'An ad will be displayed before loading the video';

  @override
  String get ok => 'OK';

  @override
  String get loading => 'Loading...';

  @override
  String errorWithReason(String reason) {
    return 'Error: $reason';
  }

  @override
  String get historyTitle => 'Full history';

  @override
  String get youtubeUrlDetected => 'YouTube URL detected and pasted!';

  @override
  String get thumbHubTitle => 'ThumbHub';

  @override
  String get thumbHubAppBarTitle => 'THUMBHUB';

  @override
  String get pasteUrlHereHint => 'Paste YouTube URL here...';

  @override
  String get pasteFromClipboard => 'Paste from Clipboard';

  @override
  String get fetchThumb => 'Fetch Thumb';

  @override
  String get communityHub => 'Community Hub';

  @override
  String viewsLabel(String count) {
    return '$count views';
  }

  @override
  String viralVideoThumbnail(int number) {
    return 'Viral Video Thumbnail $number';
  }

  @override
  String get maxResPreview => 'MaxRes Preview';

  @override
  String get selectQuality => 'Select Quality';

  @override
  String get qualityHd => 'HD';

  @override
  String get qualitySd => 'SD';

  @override
  String get qualityNormal => 'Normal';

  @override
  String get launchVideoInYoutube => 'Launch Video in YouTube';

  @override
  String get saveToGallery => 'Save to Gallery';
}
