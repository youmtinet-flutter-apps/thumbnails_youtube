import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'dart:developer';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final AdRequest request = AdRequest();

  static const interstitialButtonText = 'InterstitialAd';
  static const rewardedButtonText = 'RewardedAd';
  static const rewardedInterstitialButtonText = 'RewardedInterstitialAd';
  static const fluidButtonText = 'Fluid';
  static const inlineAdaptiveButtonText = 'Inline adaptive';
  static const anchoredAdaptiveButtonText = 'Anchored adaptive';
  static const nativeTemplateButtonText = 'Native template';
  static const webviewExampleButtonText = 'Register WebView';
  static const adInspectorButtonText = 'Ad Inspector';

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: [testDevice]));
    _createInterstitialAd();
    _createRewardedAd();
    _createRewardedInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => log('ad onAdShowedFullScreenContent.'),
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
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            log('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      log('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      },
    );
    _rewardedAd = null;
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdHelper.rewardedInterstitialAdUnitId,
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            log('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      log('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) => log('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedInterstitialAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AdMob Plugin example app'),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result) {
                    case interstitialButtonText:
                      _showInterstitialAd();
                      break;
                    case rewardedButtonText:
                      _showRewardedAd();
                      break;
                    case rewardedInterstitialButtonText:
                      _showRewardedInterstitialAd();
                      break;
                    case fluidButtonText:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FluidExample()),
                      );
                      break;
                    case inlineAdaptiveButtonText:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InlineAdaptiveExample()),
                      );
                      break;
                    case anchoredAdaptiveButtonText:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnchoredAdaptiveExample(),
                        ),
                      );
                      break;
                    case nativeTemplateButtonText:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NativeTemplateExample()),
                      );
                      break;
                    case webviewExampleButtonText:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WebViewExample()),
                      );
                      break;
                    case adInspectorButtonText:
                      MobileAds.instance.openAdInspector(
                        (error) => log(
                          'Ad Inspector ' + (error == null ? 'opened.' : 'error: ' + (error.message ?? '')),
                        ),
                      );
                      break;
                    default:
                      throw AssertionError('unexpected button: $result');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: interstitialButtonText,
                    child: Text(interstitialButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: rewardedButtonText,
                    child: Text(rewardedButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: rewardedInterstitialButtonText,
                    child: Text(rewardedInterstitialButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: fluidButtonText,
                    child: Text(fluidButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: inlineAdaptiveButtonText,
                    child: Text(inlineAdaptiveButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: anchoredAdaptiveButtonText,
                    child: Text(anchoredAdaptiveButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: nativeTemplateButtonText,
                    child: Text(nativeTemplateButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: webviewExampleButtonText,
                    child: Text(webviewExampleButtonText),
                  ),
                  PopupMenuItem<String>(
                    value: adInspectorButtonText,
                    child: Text(adInspectorButtonText),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(child: ReusableInlineExample()),
        );
      }),
    );
  }
}
