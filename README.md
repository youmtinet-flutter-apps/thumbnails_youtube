# ThumbHub

A Flutter app for fetching, previewing, and downloading YouTube video thumbnails in multiple resolutions.

## Features

- **Paste & Fetch** — Paste any YouTube URL or video ID to instantly load its thumbnail
- **Multiple Resolutions** — Preview and choose from all available thumbnail resolutions (MQ, HQ, SD, Max)
- **Download** — Save thumbnails directly to your device gallery
- **Watch on YouTube** — Open the video on YouTube with one tap
- **History** — Browse previously viewed thumbnails locally
- **Trending** — See popular thumbnails powered by Firestore statistics
- **Localization** — Supports English and French (`EN` / `FR`)
- **Dark & Light Theme** — Follows system or user preference
- **Ads** — Integrated Google Mobile Ads (banner + interstitial) with cooldown logic
- **OTA Updates** — Shorebird integration for over-the-air code patches

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| State Management | Provider + GetX |
| Backend | Firebase (Firestore) |
| Ads | Google Mobile Ads |
| Local Storage | Shared Preferences |
| Image Saving | Saver Gallery |
| Responsive UI | Flutter ScreenUtil |
| Fonts | Google Fonts |
| i18n | Flutter Localizations (ARB) |
| OTA | Shorebird |

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `^3.9.2`
- [FVM](https://fvm.app/) (recommended for version management)
- A Firebase project with Firestore enabled
- Google Mobile Ads app IDs configured

### Setup

1. **Clone the repository**

   ```bash
   git clone <repo-url>
   cd thumbhub
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   # or with FVM:
   fvm flutter pub get
   ```

3. **Firebase configuration**

   - Place your `google-services.json` in `android/app/`
   - Place your `GoogleService-Info.plist` in `ios/Runner/`
   - Update `lib/firebase_options.dart` / `lib/utils/firebase_options.dart` with your project config

4. **Run the app**

   ```bash
   flutter run
   # or with FVM:
   fvm flutter run
   ```

## Project Structure

```
lib/
├── main.dart                  # Entry point, initialization
├── app.dart                   # Home page widget
├── lib.dart                   # Barrel export
├── ads_units/                 # Banner, interstitial, native ad widgets
├── components/                # Reusable UI components
├── l10n/                      # Localization ARB files and generated delegates
├── themes/                    # Color palette and theme definitions
└── utils/
    ├── constants.dart          # Firebase initialization, app constants
    ├── models.dart             # Data models and enums
    ├── providers.dart          # AppProvider (state management)
    ├── utilities.dart          # URL parsing, history, resolution checks
    ├── firebase_methods.dart   # Firestore read/write helpers
    └── extensions.dart         # Dart extension methods
```

## Localization

ARB files are located in `lib/l10n/`. To add a new language:

1. Create `lib/l10n/intl_<lang>.arb`
2. Run `flutter gen-l10n`

## Building

```bash
# Android release APK
flutter build apk --release

# iOS release
flutter build ios --release
```

## OTA Updates (Shorebird)

```bash
shorebird release android
shorebird patch android
```

## Version

Current version: `1.1.10+21`
