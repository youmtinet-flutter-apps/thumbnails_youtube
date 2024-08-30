import 'dart:developer';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class ThmbHomePage extends StatefulWidget {
  ThmbHomePage({Key? key}) : super(key: key);

  @override
  State<ThmbHomePage> createState() => _ThmbHomePageState();
}

class _ThmbHomePageState extends State<ThmbHomePage> {
  bool showFullscreenMonitor = true;

  final GlobalKey _globalKey = GlobalKey();

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _createRewardedAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var videoId = context.watch<AppProvider>().videoId;
    var availableChoices = context.watch<AppProvider>().availableChoices;
    log('Screen Width: ${Get.width.toString()}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Thumbnails YouTube'),
        actions: [CustomThemeSwitcher()],
      ),
      key: _globalKey,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpeg'), // Your image path here
                fit: BoxFit.cover, // You can change this property according to your needs
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: Get.height,
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Gap(10),
                ...[
                  AppInputField(
                    textEditingController: context.watch<AppProvider>().textEditingController,
                    onPressed: () async {
                      if (context.read<AppProvider>().isRewardTime) {
                        _showRewardedAd(
                          context,
                          context.read<AppProvider>().textEditingController.text,
                        );
                      } else {
                        await getImageFromUrl(
                          context,
                          context.read<AppProvider>().textEditingController.text,
                        );
                      }
                    },
                  ),
                  Gap(10),
                  if (videoId.isNotEmpty) ...[
                    MainImageView(
                      showFullscreenMonitor: showFullscreenMonitor,
                      onPressed: () {
                        setState(() {
                          showFullscreenMonitor = !showFullscreenMonitor;
                        });
                      },
                    ),
                    Gap(10),
                  ],
                  Row(
                    children: [
                      if (availableChoices.isNotEmpty)
                        Expanded(
                          child: ResolutionChoiceWidget(
                            availableChoices: availableChoices,
                            controller: controller,
                          ),
                        ),
                      if (videoId.isNotEmpty) SizedBox(width: 24),
                      if (videoId.isNotEmpty) DownloadButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                  Gap(10),
                  HistoricIcon(),
                ].map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: e,
                  ),
                ),
                ReusableInlineBanner(),
                HistoricFeaturedAll(preview: true),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            /* borderRadius: BorderRadius.all(
              Radius.circular(2),
            ), */
          ),
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(Icons.paste),
          ),
        ),
        onTap: () async {
          ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
          if (data == null) return;
          var text = data.text;
          if (text == null) return;
          if (context.read<AppProvider>().isRewardTime) {
            _showRewardedAd(context, text);
          } else {
            await getImageFromUrl(context, text);
          }
        },
      ),
    );
  }

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  static final AdRequest request = AdRequest();
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

  void _showRewardedAd(BuildContext context, String text) {
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
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
        log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        await context.read<AppProvider>().updateRewardTime();
        await getImageFromUrl(context, text);
      },
    );
    _rewardedAd = null;
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }
  /* Future<void> saveLocalImage() async {
    var currCtx = _globalKey.currentContext;
    if (currCtx == null) return;
    var rendered = currCtx.findRenderObject();
    log(rendered.runtimeType.toString());
    late RenderRepaintBoundary boundary;
    if (rendered is RenderRepaintBoundary) {
      boundary = rendered;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final result = await PhotoGallerySaver.saveImage(byteData.buffer.asUint8List());
        log('$result');
      }
    }
  } */
}
