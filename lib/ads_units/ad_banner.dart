import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:thumbnail_youtube/utils/ad_helper.dart';

class ReusableInlineBanner extends StatefulWidget {
  const ReusableInlineBanner({super.key});

  @override
  _ReusableInlineBannerState createState() => _ReusableInlineBannerState();
}

class _ReusableInlineBannerState extends State<ReusableInlineBanner> {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  Widget build(BuildContext context) {
    final BannerAd? bannerAd = _bannerAd;
    if (_bannerAdIsLoaded && bannerAd != null) {
      return SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd),
      );
    }

    return SizedBox();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('$BannerAd loaded.');
          setState(() {
            _bannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }
}
