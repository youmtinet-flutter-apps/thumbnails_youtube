import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:get/get.dart';
import 'package:personal_dropdown/personal_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'package:url_launcher/url_launcher.dart';

class AppImageViewer extends StatelessWidget {
  AppImageViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'CurrentViewer',
      child: InteractiveViewer(
        child: Image(
          image: NetworkImage(context.watch<AppProvider>().thumbnail()),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          repeat: ImageRepeat.repeatX,
          loadingBuilder: (BuildContext bcntxt, Widget widget, ImageChunkEvent? i) {
            if (i == null) return widget;
            return Center(
              child: SizedBox(width: 24.r, height: 24.r, child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
          errorBuilder: (BuildContext btext, Object object, StackTrace? stackTrace) {
            return ErrorWidget(object);
          },
          frameBuilder: (BuildContext buildContext, Widget widget, int? op, bool rebuild) {
            return widget;
          },
        ),
      ),
    );
  }
}

extension ThemeSata on ThemeData {
  bool get isDarkMode => brightness == Brightness.dark;
  Color get backgroundColor => colorScheme.surface;

  Color get adaptativeTextColor => isDarkMode ? const Color(0xFFF3F3F3) : primaryColorDark;
}

class ErreurWidget extends StatelessWidget {
  ErreurWidget({Key? key, this.message}) : super(key: key);
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50.r),
      child: Column(
        children: <Widget>[
          Icon(Icons.error, color: Colors.red),
          if (message != null) Text(message ?? ''),
        ],
      ),
    );
  }
}

class MainImageView extends StatelessWidget {
  MainImageView({Key? key, required this.showFullscreenMonitor}) : super(key: key);
  final bool showFullscreenMonitor;

  Future<void> _openFullQuality(BuildContext context) async {
    final String imageUrl = context.read<AppProvider>().thumbnail(maxRes: true);
    await Get.to<void>(() => FullQualityViewerPage(imageUrl: imageUrl), duration: Duration(milliseconds: 350));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 6,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openFullQuality(context),
        child: Stack(
          children: <Widget>[
            AspectRatio(aspectRatio: 16 / 9, child: AppImageViewer()),
            if (showFullscreenMonitor)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Colors.transparent, Colors.black.withValues(alpha: 0.65)]),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(Icons.open_in_full, color: Colors.white, size: 18.r),
                      SizedBox(width: 8.r),
                      Text('Open full quality', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FullQualityViewerPage extends StatefulWidget {
  const FullQualityViewerPage({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  State<FullQualityViewerPage> createState() => _FullQualityViewerPageState();
}

class _FullQualityViewerPageState extends State<FullQualityViewerPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.back<void>(),
              child: Center(
                child: InteractiveViewer(
                  child: Hero(
                    tag: 'CurrentViewer',
                    child: Image(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                        if (progress == null) return child;
                        return Center(
                          child: SizedBox(width: 32.r, height: 32.r, child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Icon(Icons.broken_image, color: Colors.white70, size: 48.r);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.r,
            right: 16.r,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Get.back<void>(),
                icon: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppInputField extends StatelessWidget {
  AppInputField({Key? key, this.onPressed, required this.textEditingController}) : super(key: key);
  final void Function()? onPressed;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        hintText: 'Paste a YouTube URL',
        prefixIcon: Icon(Icons.link),
        suffixIcon: IconButton(onPressed: onPressed, icon: Icon(Icons.search)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.2),
        ),
      ),
    );
  }
}

class StackLoading extends StatelessWidget {
  const StackLoading({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wa-doodle.png'), // Your image path here
              repeat: ImageRepeat.repeat, // You can change this property according to your needs
            ),
          ),
        ),
        Container(width: Get.width, height: Get.height, color: Colors.black.withValues(alpha: 0.5)),
        child,
        if (context.watch<AppProvider>().loading)
          AbsorbPointer(
            absorbing: true,
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

class ResolutionChoiceWidget extends StatelessWidget {
  ResolutionChoiceWidget({Key? key, required this.availableChoices, required this.controller}) : super(key: key);

  final List<RsolutionEnum> availableChoices;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      searchFunction: (String e, String searchPrompt) => e.contains(searchPrompt),
      searchableTextItem: (String item) => item,
      hintText: 'Resolution',
      items: availableChoices.map((RsolutionEnum e) => e.getResourceFromEnum()).toList(),
      itemBgColor: Theme.of(context).colorScheme.primary,
      fillColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey),
      onItemSelect: (String? value) {
        context.read<AppProvider>().setResolution(parseResolutionString(value));
      },
      excludeSelected: false,
      listItemBuilder: (BuildContext context, String result) {
        return Text(
          result,
          style: context.watch<AppProvider>().resolution.getResourceFromEnum() == result ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold) : null,
        );
      },
      selectedStyle: TextStyle(fontWeight: FontWeight.bold, color: context.isDarkMode ? Color(0xFFFFFFFF) : context.theme.colorScheme.primary),
      /* onChanged: (value) {
        controller.text = value;
      }, */
      controller: controller,
    );
  }
}

Future<Uint8List> getUint8ListFromImagePath(String url) async {
  HttpClientRequest download = await HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse response = await download.close();
  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  return bytes;
}

class DownloadButton extends StatelessWidget {
  DownloadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () async {
        try {
          context.read<AppProvider>().setLoading(true);
          String path = context.read<AppProvider>().thumbnail();
          Uint8List bites = await getUint8ListFromImagePath(path);
          SaveResult afterSave = await SaverGallery.saveImage(bites, skipIfExists: true, fileName: basename(path));
          if (!afterSave.isSuccess) return;
          appSnackbar(context, 'Infos', "Image downloaded successfully!");
          context.read<AppProvider>().setLoading(false);
        } on Exception catch (_) {
          context.read<AppProvider>().setLoading(false);
        }
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[primary.withBlue((primary.b * 255.0).round().clamp(0, 255) + 50), primary]),
          color: primary,
        ),
        child: Icon(Icons.download, color: Colors.white),
      ),
    );
  }
}

class WatchOnYouTubeButton extends StatelessWidget {
  const WatchOnYouTubeButton({Key? key, required this.videoId}) : super(key: key);

  final String videoId;

  Future<void> _launchVideo(BuildContext context) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    final bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!launched) {
      appSnackbar(context, 'Error', 'Could not open YouTube');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: videoId.isEmpty ? null : () => _launchVideo(context),
      icon: Icon(Icons.play_circle_fill),
      label: Text('Watch on YouTube'),
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
        shape: StadiumBorder(),
      ),
    );
  }
}
