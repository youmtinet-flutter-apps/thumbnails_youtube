import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
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
  Widget build(BuildContext context) {
    var videoId = context.watch<AppProvider>().videoId;
    var availableChoices = context.watch<AppProvider>().availableChoices;
    return Scaffold(
      appBar: AppBar(
        title: Text('Thumbnails YouTube'),
        actions: [CustomThemeSwitcher()],
      ),
      key: _globalKey,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Gap(30),
            ...[
              AppInputField(
                textEditingController: context.watch<AppProvider>().textEditingController,
                onPressed: () async {
                  await getImageFromUrl(
                    context.watch<AppProvider>().textEditingController.text,
                    context,
                  );
                },
              ),
              Gap(20),
              if (videoId.isNotEmpty) ...[
                MainImageView(
                  showFullscreenMonitor: showFullscreenMonitor,
                  onPressed: () {
                    setState(() {
                      showFullscreenMonitor = !showFullscreenMonitor;
                    });
                  },
                ),
                Gap(20),
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
              Gap(20),
              HistoricIcon(),
            ].map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: e,
                )),
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
          await getImageFromUrl(text, context);
        },
      ),
    );
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
