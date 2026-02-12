import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class ThmbHomePage extends StatefulWidget {
  ThmbHomePage({Key? key}) : super(key: key);

  @override
  State<ThmbHomePage> createState() => _ThmbHomePageState();
}

class _ThmbHomePageState extends State<ThmbHomePage> {
  bool showFullscreenMonitor = true;

  final GlobalKey<ReusableInterstitialAdsState> _globalKey = GlobalKey<ReusableInterstitialAdsState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String videoId = context.watch<AppProvider>().videoId;
    List<RsolutionEnum> availableChoices = context.watch<AppProvider>().availableChoices;
    return StackLoading(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thumbnails YouTube'),
          titleTextStyle: TextStyle(color: context.theme.textTheme.titleLarge?.color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.r,
            children: <Widget>[
              ReusableInterstitialAds(
                key: _globalKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.r),
                  child: AppInputField(
                    textEditingController: context.watch<AppProvider>().textEditingController,
                    onPressed: () async {
                      String text2 = context.read<AppProvider>().textEditingController.text;
                      await getImageFromUrl(context, text2);
                      if (context.read<AppProvider>().isAdsTime) {
                        await _globalKey.currentState?.showInterstitialAdIfAvailable();
                      }

                      await getImageFromUrl(context, text2);
                    },
                  ),
                ),
              ),
              if (videoId.isNotEmpty)
                MainImageView(
                  showFullscreenMonitor: showFullscreenMonitor,
                  onPressed: () {
                    setState(() {
                      showFullscreenMonitor = !showFullscreenMonitor;
                    });
                  },
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.r),
                child: Row(
                  spacing: 12.r,
                  children: <Widget>[
                    if (availableChoices.isNotEmpty)
                      Expanded(
                        child: ResolutionChoiceWidget(availableChoices: availableChoices, controller: context.watch<AppProvider>().resolutionSelectionController),
                      ),
                    if (videoId.isNotEmpty) DownloadButton(),
                  ],
                ),
              ),
              HistoricIcon(),

              ReusableInlineBanner(),
              HistoricFeaturedAll(preview: true),
            ],
          ),
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
            child: Padding(padding: EdgeInsets.all(18.0.w), child: Icon(Icons.paste)),
          ),
          onTap: () async {
            try {
              context.read<AppProvider>().setLoading(true);
              context.read<AppProvider>().setResolution(RsolutionEnum.mqdefault);
              ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
              if (data == null) return;
              String? text = data.text;
              if (text == null) return;
              await getImageFromUrl(context, text);
              if (context.read<AppProvider>().isAdsTime) {
                await _globalKey.currentState?.showInterstitialAdIfAvailable();
              }
              context.read<AppProvider>().setLoading(false);
            } on Exception catch (_) {
              context.read<AppProvider>().setLoading(false);
              appSnackbar(context, 'Error', "Une erreur s'est produite lors du chargement de la vidéo");
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /* Future<void> saveLocalImage() async {
    var currCtx = _globalKey.currentContext;
    if (currCtx == null) return;
    var rendered = currCtx.findRenderObject();
    log (rendered.runtimeType.toString());
    late RenderRepaintBoundary boundary;
    if (rendered is RenderRepaintBoundary) {
      boundary = rendered;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final result = await PhotoGallerySaver.saveImage(byteData.buffer.asUint8List());
        log ('$result');
      }
    }
  } */
}
