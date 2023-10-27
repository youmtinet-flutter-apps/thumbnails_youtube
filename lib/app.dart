import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
/* import 'dart:ui' as ui; */

import 'package:thumbnail_youtube/lib.dart';

class ThmbHomePage extends StatefulWidget {
  const ThmbHomePage({Key? key}) : super(key: key);

  @override
  State<ThmbHomePage> createState() => _ThmbHomePageState();
}

class _ThmbHomePageState extends State<ThmbHomePage> {
  bool showFullscreenMonitor = true;

  final GlobalKey _globalKey = GlobalKey();
  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var videoId = context.watch<AppProvider>().videoId;
    var availableChoices = context.watch<AppProvider>().availableChoices;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thumbnails YouTube'),
        actions: const [CuistomThemeSwitcher()],
      ),
      key: _globalKey,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            AppInputField(
              textEditingController: context.watch<AppProvider>().textEditingController,
              onPressed: () async {
                await getImageFromUrl(
                  context.watch<AppProvider>().textEditingController.text,
                  context,
                );
              },
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
            Row(
              children: [
                if (availableChoices.isNotEmpty)
                  Expanded(
                    child: ResolutionChoiceWidget(availableChoices: availableChoices),
                  ),
                const DownloadButton(),
                const SizedBox(height: 20),
              ],
            ),
            const HistoricIcon(),
            const HistoricBuilder(preview: true),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        child: Container(
          decoration: const BoxDecoration(
            color: primaryColor,
            /* shape: BoxShape.circle,
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ), */
          ),
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(Icons.paste),
          ),
        ),
        onTap: () async {
          ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
          if (data != null) {
            var text = data.text;
            if (text != null) {
              await getImageFromUrl(text, context);
            }
          }
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
