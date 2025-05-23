import 'dart:developer';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:get/get.dart';
import 'package:personal_dropdown/personal_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class AppImageViewer extends StatelessWidget {
  AppImageViewer({
    Key? key,
  }) : super(key: key);

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

class CustomThemeSwitcher extends StatelessWidget {
  CustomThemeSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher.switcher(
      builder: (_, switcher) {
        return IconButton(
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                return Icon(CupertinoIcons.moon_stars);
              } else {
                return Icon(CupertinoIcons.sun_haze);
              }
            }(),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: RotationTransition(
                    turns: animation,
                    child: child,
                  ),
                ),
              );
            },
          ),
          onPressed: () async {
            // Debug START
            RenderObject? boundary = context.findRenderObject();
            if (boundary == null) {
              log('boundary');
              return;
            }
            bool debugNeedsPaint = false;
            if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;
            if (debugNeedsPaint) {
              log('debugNeedsPaint');
              return;
            }
            // Debug END
            final bool prevDark = context.theme.isDarkMode;
            // Get.changeThemeMode(!prevDark ? ThemeMode.light : ThemeMode.dark);
            await saveThemeModePrefs(prevDark ? Brightness.light : Brightness.dark);
            switcher.changeTheme(theme: theme(!prevDark), isReversed: prevDark);
          },
        );
      },
    );
  }
}

class ErreurWidget extends StatelessWidget {
  ErreurWidget({
    Key? key,
    this.message,
  }) : super(key: key);
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          if (message != null) Text(message ?? '')
        ],
      ),
    );
  }
}

class MainImageView extends StatelessWidget {
  MainImageView({
    Key? key,
    this.onPressed,
    required this.showFullscreenMonitor,
  }) : super(key: key);
  final void Function()? onPressed;
  final bool showFullscreenMonitor;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Stack(
        children: [
          // SizedBox(height: 300, width: Get.width),
          Material(
            child: InkWell(
              onTap: onPressed,
              child: Align(
                alignment: Alignment.center,
                child: AppImageViewer(),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: showFullscreenMonitor
                ? Material(
                    child: InkWell(
                      onTap: () async {
                        /* await Get.generalDialog(
                          barrierColor: Colors.white,
                          barrierDismissible: true,
                          barrierLabel: 'Close',
                          transitionDuration: Duration(seconds: 2),
                          transitionBuilder: (context, animation, secondaryAnimation, child) {
                            return SizeTransition(
                              sizeFactor: animation,
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return SizeTransition(
                              sizeFactor: animation,
                              child: Transform.rotate(
                                angle: 90.toRadian,
                                child: Hero(
                                  tag: 'CurrentViewer',
                                  child: Image(
                                    image: NetworkImage(
                                      context.watch<AppProvider>().thumbnail(maxRes: true),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ); */
                        await Get.to<void>(
                          () => Scaffold(
                            body: Center(
                              child: Transform.rotate(
                                angle: (90).toRadian,
                                child: Hero(
                                  tag: 'CurrentViewer',
                                  child: Image(
                                    image: NetworkImage(
                                      context.watch<AppProvider>().thumbnail(maxRes: true),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          duration: Duration(milliseconds: 400),
                        );
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
    });
  }
}

class AppInputField extends StatelessWidget {
  AppInputField({
    Key? key,
    this.onPressed,
    required this.textEditingController,
  }) : super(key: key);
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
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: []),
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

class ResolutionChoiceWidget extends StatelessWidget {
  ResolutionChoiceWidget({
    Key? key,
    required this.availableChoices,
    required this.controller,
  }) : super(key: key);

  final List<RsolutionEnum> availableChoices;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      searchFunction: (e, searchPrompt) => e.contains(searchPrompt),
      searchableTextItem: (item) => item,
      hintText: 'Resolution',
      items: availableChoices.map((e) => e.resFrmEnum()).toList(),
      itemBgColor: Colors.amber,
      fillColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey),
      onItemSelect: (String? value) {
        context.read<AppProvider>().setResolution(resFrmStr(value));
      },
      excludeSelected: false,
      listItemBuilder: (BuildContext context, String result) {
        return Text(
          result,
          style: context.watch<AppProvider>().resolution.resFrmEnum() == result
              ? TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              : null,
        );
      },
      selectedStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
      /* onChanged: (value) {
        controller.text = value;
      }, */
      controller: controller,
    );
  }
}

Future<Uint8List> getUint8ListFromImagePath(String imagePath) async {
  File imageFile = File(imagePath);
  return await imageFile.readAsBytes();
}

class DownloadButton extends StatelessWidget {
  DownloadButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () async {
        String path = context.read<AppProvider>().thumbnail();
        Uint8List bites = await getUint8ListFromImagePath(path);
        SaveResult afterSave = await SaverGallery.saveImage(
          bites,
          skipIfExists: true,
          fileName: basename(path),
          //   albumName: PreferencesKeys.videoThumnails.name,
        );

        // if (afterSave == null) return;

        if (!afterSave.isSuccess) return;
        appSnackbar(context, 'Infos', "Image downloaded successfully!");
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primary.withBlue(primary.blue + 50),
              primary,
            ],
          ),
          color: primary,
        ),
        child: Icon(
          Icons.download,
          color: Colors.white,
        ),
      ),
    );
  }
}
