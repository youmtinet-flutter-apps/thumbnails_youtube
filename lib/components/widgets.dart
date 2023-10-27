import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:personal_dropdown/personal_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart';

class AppImageViewer extends StatelessWidget {
  const AppImageViewer({
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
              child: const Align(
                alignment: Alignment.center,
                child: AppImageViewer(),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: showFullscreenMonitor
                ? Material(
                    child: InkWell(
                      onTap: () async {
                        /* await Get.generalDialog(
                          barrierColor: Colors.white,
                          barrierDismissible: true,
                          barrierLabel: 'Close',
                          transitionDuration: const Duration(seconds: 2),
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
                        Get.to(
                          () => Scaffold(
                            appBar: AppBar(),
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
                          duration: const Duration(milliseconds: 400),
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
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: onPressed,
            child: Container(
              margin: const EdgeInsets.only(right: 4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
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
  ResolutionChoiceWidget({
    Key? key,
    required this.availableChoices,
  }) : super(key: key);

  final List<RsolutionEnum> availableChoices;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomDropdown<String>.search(
        searchFunction: (e, searchPrompt) => e.contains(searchPrompt),
        searchableTextItem: (item) => item,
        hintText: 'Resolution',
        items: [...availableChoices.map((e) => e.resFrmEnum())],
        fillColor: Get.theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
        onItemSelect: (String? value) {
          context.read<AppProvider>().setResolution(resFrmStr(value));
        },
        excludeSelected: true,
        listItemBuilder: (BuildContext context, String result) {
          return Text(
            result,
            style: context.watch<AppProvider>().resolution.resFrmEnum() == result
                ? TextStyle(
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  )
                : null,
          );
        },
        selectedStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Get.theme.primaryColor,
        ),
        onChanged: (value) {
          controller.text = value;
        },
        controller: controller,
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String path = context.watch<AppProvider>().thumbnail();
        bool? afterSave = await GallerySaver.saveImage(
          path,
          toDcim: false,
          albumName: PreferencesKeys.videoThumnails.name,
        );

        await context.read<AppProvider>().addDownload(context);

        if (afterSave == null) return;

        if (!afterSave) return;
        appSnackbar('Infos', "Image downloaded successfully!");
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
              primaryColor.withBlue(primaryColor.blue + 50),
              primaryColor,
            ],
          ),
          color: primaryColor,
        ),
        child: const Icon(
          Icons.download,
          color: Colors.white,
        ),
      ),
    );
  }
}
