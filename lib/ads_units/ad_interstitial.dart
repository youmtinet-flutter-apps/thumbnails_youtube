import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'dart:developer';

class ReusableInterstitialAds extends StatefulWidget {
  final Widget child;

  const ReusableInterstitialAds({super.key, required this.child});

  @override
  ReusableInterstitialAdsState createState() => ReusableInterstitialAdsState();
}

class ReusableInterstitialAdsState extends State<ReusableInterstitialAds> {
  static final AdRequest request = AdRequest();

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  void initState() {
    _createInterstitialAd();
    super.initState();
  }

  Future<void> _createInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  Future<void> showInterstitialAd(String text) async {
    if (_interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.', name: 'warning');
      return;
    }
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => log('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
    await context.read<AppProvider>().updateAdsTime();
    await getImageFromUrl(context, text);
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(context.read<AppProvider>().isAdsTime.toString());
    return widget.child;
  }
}
