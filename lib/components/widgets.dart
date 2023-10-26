import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class MainImageview extends StatelessWidget {
  const MainImageview({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Image(
        image: NetworkImage(url),
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
    );
  }
}

class ThemeToggeller extends StatelessWidget {
  const ThemeToggeller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Get.isDarkMode ? const Icon(CupertinoIcons.moon_stars) : const Icon(CupertinoIcons.sun_haze),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: RotationTransition(
            turns: animation,
            child: child,
          ),
        );
      },
    );
  }
}

class CuistomThemeSwitcher extends StatelessWidget {
  const CuistomThemeSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (bcontext) => IconButton(
        icon: const ThemeToggeller(),
        onPressed: () async {
          RenderObject? boundary = bcontext.findRenderObject();
          if (boundary != null) {
            bool debugNeedsPaint = false;
            if (!kDebugMode) {
              await quickSwitch(bcontext);
              return;
            }
            if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;

            if (!debugNeedsPaint) {
              await quickSwitch(bcontext);
            } else {
              ////
            }
          } else {
            ////
          }
        },
      ),
    );
  }

  Future<void> quickSwitch(BuildContext bcontext) async {
    final theme = Get.isDarkMode ? lightTheme : darkTheme;
    final switcher = ThemeSwitcher.of(bcontext);
    await saveThemeModePrefs(Get.isDarkMode ? Brightness.light : Brightness.dark);
    switcher.changeTheme(theme: theme, isReversed: Get.isDarkMode);
  }
}

class ExampleSizeTransitions extends StatelessWidget {
  const ExampleSizeTransitions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Size Transitions"),
        actions: const [CuistomThemeSwitcher()],
      ),
      body: ButtonScaleTransition(
        onPressed: () {
          log('text${DateTime.now()}');
        },
        child: const Center(
          child: Card(
            color: Color(0xFF33D601),
            child: SizedBox(
              width: 250,
              height: 100,
              child: Text(
                "Size Transitions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ErreurWidget extends StatelessWidget {
  const ErreurWidget({
    Key? key,
    this.message,
  }) : super(key: key);
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          const Icon(
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
  const MainImageView({
    Key? key,
    required RsolutionEnum resolution,
    required this.videoId,
    this.onPressed,
    required this.showFullscreenMonitor,
  })  : _resolution = resolution,
        super(key: key);
  final void Function()? onPressed;
  final RsolutionEnum _resolution;
  final String videoId;
  final bool showFullscreenMonitor;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var res = _resolution.name;
      var url = "https://i.ytimg.com/vi/$videoId/$res.jpg";
      return Stack(
        children: [
          // SizedBox(height: 300, width: Get.width),
          Material(
            child: InkWell(
              onTap: onPressed,
              child: Align(
                alignment: Alignment.center,
                child: MainImageview(url: url),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: showFullscreenMonitor
                ? Material(
                    child: InkWell(
                      onTap: () async {
                        await Get.generalDialog(
                          // transitionDuration: const Duration(seconds: 1),
                          transitionBuilder: (context, animation, secondaryAnimation, child) {
                            return SizeTransition(
                              sizeFactor: animation,
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return Scaffold(
                              body: SizeTransition(
                                sizeFactor: animation,
                                child: Transform.rotate(
                                  angle: 90.toRadian,
                                  child: MainImageview(url: url),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Align(
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
  const AppInputField({
    Key? key,
    this.onPressed,
    required this.textEditingController,
  }) : super(key: key);
  final void Function()? onPressed;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: onPressed,
            child: Container(
              margin: const EdgeInsets.only(right: 4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          prefixText: "https://",
          helperText: "URI de video",
          hintText: 'Video url',
        ),
      ),
    );
  }
}

class AppFABclipdata extends StatelessWidget {
  const AppFABclipdata({Key? key, this.onPressed}) : super(key: key);
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Clipboard',
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      child: const Icon(Icons.paste),
    );
  }
}

class ResolutionChoiceWidget extends StatelessWidget {
  final void Function(RsolutionEnum?)? onChanged;

  const ResolutionChoiceWidget({
    Key? key,
    required RsolutionEnum resolution,
    this.onChanged,
    required this.availableChoices,
  })  : _resolution = resolution,
        super(key: key);

  final RsolutionEnum _resolution;
  final List<RsolutionEnum> availableChoices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<RsolutionEnum>(
        isExpanded: true,
        value: _resolution,
        autofocus: true,
        elevation: 10,
        /* selectedItemBuilder: (BuildContext _context) {
            return [];
          }, */
        decoration: const InputDecoration(fillColor: Colors.black),
        borderRadius: BorderRadius.circular(20),
        icon: const Icon(Icons.downloading_sharp),
        alignment: Alignment.center,
        items: availableChoices.map((e) {
          return DropdownMenuItem<RsolutionEnum>(
            value: e,
            child: Text(e.resFrmEnum()),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    Key? key,
    required RsolutionEnum resolution,
    required this.videoId,
  })  : _resolution = resolution,
        super(key: key);

  final RsolutionEnum _resolution;
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var res = _resolution.name;
        String path = "https://i.ytimg.com/vi/$videoId/$res.jpg";
        bool? afterSave = await GallerySaver.saveImage(
          path,
          toDcim: false,
          albumName: PreferencesKeys.videoThumnails.name,
        );

        await firestoreStatistics(Incremente.downloads, videoId, context);
        context.read<AppProvider>().addDownload(videoId);

        if (afterSave == null) return;

        if (!afterSave) return;
        appSnackbar('Infos', "Image downloaded successfully!");
      },
      child: Container(
        width: Get.width * 0.75,
        height: 60,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Download',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            Icon(
              Icons.download,
              color: Colors.white,
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withBlue(primaryColor.blue + 50),
              primaryColor,
            ],
          ),
          color: primaryColor,
        ),
      ),
    );
  }
}
