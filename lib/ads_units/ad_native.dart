import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:thumbnail_youtube/utils/ad_helper.dart';

class ReusableInlineNative extends StatefulWidget {
  const ReusableInlineNative({super.key});

  @override
  _ReusableInlineNativeState createState() => _ReusableInlineNativeState();
}

class _ReusableInlineNativeState extends State<ReusableInlineNative> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  Widget build(BuildContext context) {
    final NativeAd? nativeAd = _nativeAd;
    if (_nativeAdIsLoaded && nativeAd != null) {
      return SizedBox(width: 250, height: 350, child: AdWidget(ad: nativeAd));
    }

    return SizedBox();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          log('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => log('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }
}
