import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:get/get.dart';
import 'package:personal_dropdown/personal_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class AppImageViewer extends StatelessWidget {
  AppImageViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'CurrentViewer',
      child: InteractiveViewer(
        child: Image(
          image: NetworkImage(context.watch<AppProvider>().thumbnail()),
          repeat: ImageRepeat.repeatX,
          loadingBuilder: (BuildContext bcntxt, Widget widget, ImageChunkEvent? i) {
            return widget;
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
  MainImageView({Key? key, this.onPressed, required this.showFullscreenMonitor}) : super(key: key);
  final void Function()? onPressed;
  final bool showFullscreenMonitor;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            // SizedBox(height: 300, width: Get.width),
            Material(
              child: InkWell(
                onTap: onPressed,
                child: Align(alignment: Alignment.center, child: AppImageViewer()),
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: showFullscreenMonitor
                  ? Material(
                      child: InkWell(
                        onTap: () async {
                          await Get.generalDialog(
                            barrierColor: Colors.white,
                            barrierDismissible: true,
                            barrierLabel: 'Close',
                            transitionDuration: Duration(seconds: 2),
                            transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                              return SizeTransition(sizeFactor: animation, child: child);
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: Transform.rotate(
                                  angle: 90.toRadian,
                                  child: Hero(
                                    tag: 'CurrentViewer',
                                    child: Image(image: NetworkImage(context.watch<AppProvider>().thumbnail(maxRes: true))),
                                  ),
                                ),
                              );
                            },
                          );
                          /* await Get.to<void>(
                            () => Scaffold(
                              body: Center(
                                child: Transform.rotate(
                                  angle: (90).toRadian,
                                  child: Hero(
                                    tag: 'CurrentViewer',
                                    child: Image(image: NetworkImage(context.watch<AppProvider>().thumbnail(maxRes: true))),
                                  ),
                                ),
                              ),
                            ),
                            duration: Duration(milliseconds: 400),
                          ); */
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(child: SizedBox()),
                              Icon(Icons.fullscreen),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        );
      },
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
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: <BoxShadow>[]),
            child: Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.search)),
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        prefixText: "https://",
        hintText: 'video_url_youtube',
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
      itemBgColor: Colors.amber,
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
