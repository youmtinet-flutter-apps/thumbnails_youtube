// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Miniatures YouTube';

  @override
  String get videoLoadError =>
      'Une erreur s\'est produite lors du chargement de la vidéo';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get infoTitle => 'Infos';

  @override
  String get invalidUrl => 'URI non valide';

  @override
  String get pasteYoutubeUrlHint => 'Collez une URL YouTube';

  @override
  String get openFullQuality => 'Ouvrir en pleine résolution';

  @override
  String get resolutionLabel => 'Résolution';

  @override
  String get downloadSuccess => 'Image téléchargée avec succès !';

  @override
  String get watchOnYoutube => 'Regarder sur YouTube';

  @override
  String get youtubeOpenFailed => 'Impossible d\'ouvrir YouTube';

  @override
  String get adsDialogTitle => 'Publicité';

  @override
  String get adsDialogMessage =>
      'Une publicité va être affichée avant de charger la vidéo';

  @override
  String get ok => 'OK';

  @override
  String get loading => 'Chargement...';

  @override
  String errorWithReason(String reason) {
    return 'Erreur : $reason';
  }

  @override
  String get historyTitle => 'Historique complet';

  @override
  String get youtubeUrlDetected => 'URL YouTube détectée et collée !';

  @override
  String get thumbHubTitle => 'ThumbHub';

  @override
  String get thumbHubAppBarTitle => 'THUMBHUB';

  @override
  String get pasteUrlHereHint => 'Collez l\'URL YouTube ici...';

  @override
  String get pasteFromClipboard => 'Coller depuis le presse-papiers';

  @override
  String get fetchThumb => 'Récupérer la miniature';

  @override
  String get communityHub => 'Hub communautaire';

  @override
  String viewsLabel(String count) {
    return '$count vues';
  }

  @override
  String viralVideoThumbnail(int number) {
    return 'Miniature vidéo virale $number';
  }

  @override
  String get maxResPreview => 'Aperçu MaxRes';

  @override
  String get selectQuality => 'Sélectionnez la qualité';

  @override
  String get qualityHd => 'HD';

  @override
  String get qualitySd => 'SD';

  @override
  String get qualityNormal => 'Normal';

  @override
  String get launchVideoInYoutube => 'Ouvrir la vidéo sur YouTube';

  @override
  String get saveToGallery => 'Enregistrer dans la galerie';
}
