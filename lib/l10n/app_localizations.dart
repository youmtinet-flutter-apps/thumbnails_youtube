import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Thumbnails YouTube'**
  String get appTitle;

  /// Generic video loading failure
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the video'**
  String get videoLoadError;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// Generic info title
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoTitle;

  /// Invalid YouTube URL message
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get invalidUrl;

  /// Hint for the main URL input
  ///
  /// In en, this message translates to:
  /// **'Paste a YouTube URL'**
  String get pasteYoutubeUrlHint;

  /// Call to open the full quality image
  ///
  /// In en, this message translates to:
  /// **'Open full quality'**
  String get openFullQuality;

  /// Label for resolution dropdown
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolutionLabel;

  /// Toast when image is saved
  ///
  /// In en, this message translates to:
  /// **'Image downloaded successfully!'**
  String get downloadSuccess;

  /// Button text to open YouTube
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get watchOnYoutube;

  /// Error when opening YouTube fails
  ///
  /// In en, this message translates to:
  /// **'Could not open YouTube'**
  String get youtubeOpenFailed;

  /// Dialog title before showing an ad
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get adsDialogTitle;

  /// Dialog message before showing an ad
  ///
  /// In en, this message translates to:
  /// **'An ad will be displayed before loading the video'**
  String get adsDialogMessage;

  /// Affirmative action label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Loading placeholder
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message with reason
  ///
  /// In en, this message translates to:
  /// **'Error: {reason}'**
  String errorWithReason(String reason);

  /// AppBar title for the history page
  ///
  /// In en, this message translates to:
  /// **'Full history'**
  String get historyTitle;

  /// SnackBar when URL is pasted from clipboard
  ///
  /// In en, this message translates to:
  /// **'YouTube URL detected and pasted!'**
  String get youtubeUrlDetected;

  /// ThumbHub application title
  ///
  /// In en, this message translates to:
  /// **'ThumbHub'**
  String get thumbHubTitle;

  /// ThumbHub app bar title
  ///
  /// In en, this message translates to:
  /// **'THUMBHUB'**
  String get thumbHubAppBarTitle;

  /// Hint inside ThumbHub text field
  ///
  /// In en, this message translates to:
  /// **'Paste YouTube URL here...'**
  String get pasteUrlHereHint;

  /// Button label to paste from clipboard
  ///
  /// In en, this message translates to:
  /// **'Paste from Clipboard'**
  String get pasteFromClipboard;

  /// Button label to fetch thumbnail
  ///
  /// In en, this message translates to:
  /// **'Fetch Thumb'**
  String get fetchThumb;

  /// Section header for community hub
  ///
  /// In en, this message translates to:
  /// **'Community Hub'**
  String get communityHub;

  /// Label showing view count
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String viewsLabel(String count);

  /// Mock thumbnail title with index
  ///
  /// In en, this message translates to:
  /// **'Viral Video Thumbnail {number}'**
  String viralVideoThumbnail(int number);

  /// App bar title for max resolution preview
  ///
  /// In en, this message translates to:
  /// **'MaxRes Preview'**
  String get maxResPreview;

  /// Prompt to select quality
  ///
  /// In en, this message translates to:
  /// **'Select Quality'**
  String get selectQuality;

  /// HD quality label
  ///
  /// In en, this message translates to:
  /// **'HD'**
  String get qualityHd;

  /// SD quality label
  ///
  /// In en, this message translates to:
  /// **'SD'**
  String get qualitySd;

  /// Normal quality label
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get qualityNormal;

  /// Button label to launch video in YouTube
  ///
  /// In en, this message translates to:
  /// **'Launch Video in YouTube'**
  String get launchVideoInYoutube;

  /// Button label to save thumbnail to gallery
  ///
  /// In en, this message translates to:
  /// **'Save to Gallery'**
  String get saveToGallery;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
