import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'dart:io' show Platform;

class ReusableInlineExample extends StatefulWidget {
  const ReusableInlineExample({super.key});

  @override
  _ReusableInlineExampleState createState() => _ReusableInlineExampleState();
}

class _ReusableInlineExampleState extends State<ReusableInlineExample> {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  AdManagerBannerAd? _adManagerBannerAd;
  bool _adManagerBannerAdIsLoaded = false;

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          itemCount: 20,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 40,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final BannerAd? bannerAd = _bannerAd;
            if (index == 5 && _bannerAdIsLoaded && bannerAd != null) {
              return SizedBox(height: bannerAd.size.height.toDouble(), width: bannerAd.size.width.toDouble(), child: AdWidget(ad: bannerAd));
            }

            final AdManagerBannerAd? adManagerBannerAd = _adManagerBannerAd;
            if (index == 10 && _adManagerBannerAdIsLoaded && adManagerBannerAd != null) {
              return SizedBox(height: adManagerBannerAd.sizes[0].height.toDouble(), width: adManagerBannerAd.sizes[0].width.toDouble(), child: AdWidget(ad: _adManagerBannerAd!));
            }

            final NativeAd? nativeAd = _nativeAd;
            if (index == 15 && _nativeAdIsLoaded && nativeAd != null) {
              return SizedBox(width: 250, height: 350, child: AdWidget(ad: nativeAd));
            }

            return Text(
              Constants.placeholderText,
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid ? bannerAd2Android : bannerAd2Ios,
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
        request: AdRequest())
      ..load();

    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid ? nativeAdAndroid : nativeAdIos,
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
    _bannerAd?.dispose();
    _adManagerBannerAd?.dispose();
    _nativeAd?.dispose();
  }
}

class ReusableInlineSeparated extends StatefulWidget {
  const ReusableInlineSeparated({super.key});

  @override
  _ReusableInlineSeparatedState createState() => _ReusableInlineSeparatedState();
}

class _ReusableInlineSeparatedState extends State<ReusableInlineSeparated> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      separatorBuilder: (BuildContext context, int index) {
        return index % 8 == 0 ? ReusableInlineBanner() : SizedBox(height: 20);
      },
      itemBuilder: (BuildContext context, int index) {
        return Text(
          Constants.placeholderText,
          style: TextStyle(fontSize: 24),
        );
      },
    );
  }
}
