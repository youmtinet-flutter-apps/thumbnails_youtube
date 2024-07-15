import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ReusableInlineManagerBanner extends StatefulWidget {
  const ReusableInlineManagerBanner({super.key});

  @override
  _ReusableInlineManagerBannerState createState() => _ReusableInlineManagerBannerState();
}

class _ReusableInlineManagerBannerState extends State<ReusableInlineManagerBanner> {
  AdManagerBannerAd? _adManagerBannerAd;
  bool _adManagerBannerAdIsLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final AdManagerBannerAd? adManagerBannerAd = _adManagerBannerAd;
        if (_adManagerBannerAdIsLoaded && adManagerBannerAd != null) {
          return SizedBox(
            height: adManagerBannerAd.sizes[0].height.toDouble(),
            width: adManagerBannerAd.sizes[0].width.toDouble(),
            child: AdWidget(ad: _adManagerBannerAd!),
          );
        }

        return SizedBox();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.

    _adManagerBannerAd = AdManagerBannerAd(
      adUnitId: '/6499/example/banner',
      request: AdManagerAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[AdSize.largeBanner],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          log('$AdManagerBannerAd loaded.');
          setState(() {
            _adManagerBannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$AdManagerBannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log('$AdManagerBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => log('$AdManagerBannerAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _adManagerBannerAd?.dispose();
  }
}
