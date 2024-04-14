import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:personal_dropdown/personal_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:thumbnail_youtube/lib.dart' hide GallerySaver;

class ThemeTogglerClipper implements ThemeSwitcherClipper {
  ThemeTogglerClipper();
  @override
  Path getClip(Size size, Offset offset, double sizeRate) {
    Path path = Path();

    path.moveTo(offset.dx + sizeRate * 2 * (size.width * (0.87 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.13 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.12 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.11 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.09 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.04 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.08 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.05 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.07 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.05 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.06 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.06 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.05 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.07 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.05 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.08 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.04 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.09 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.03 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.11 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.03 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.12 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.03 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.13 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.03 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.87 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.03 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.88 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.03 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.89 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.04 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.91 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.05 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.92 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.05 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.93 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.06 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.94 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.07 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.95 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.08 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.95 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.09 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.96 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.11 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.12 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.13 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.42 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.42 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.65 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.29 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.65 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.29 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.5 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.42 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.5 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.42 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.39 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.42 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.26 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.5 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.18 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.61 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.18 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.73 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.19 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.73 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.32 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.67 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.32 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.6 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.32 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.58 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.36 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.58 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.4 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.58 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.5 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.72 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.5 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.7 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.65 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.58 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.65 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.58 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.87 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.88 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.89 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.97 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.91 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.96 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.92 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.95 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.93 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.95 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.94 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.94 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.95 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.93 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.95 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.92 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.96 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.91 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.97 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.89 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.97 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.88 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.97 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.87 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.97 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.13 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.97 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.12 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.97 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.11 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.96 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.09 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.95 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.08 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.95 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.07 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.94 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.06 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.93 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.05 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.92 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.05 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.91 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.04 - .5)));
    path.cubicTo(offset.dx + sizeRate * 2 * (size.width * (0.89 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.88 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)), offset.dx + sizeRate * 2 * (size.width * (0.87 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)));
    path.lineTo(offset.dx + sizeRate * 2 * (size.width * (0.87 - .5)), offset.dy + sizeRate * 2 * (size.height * (0.03 - .5)));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper, Offset? offset, double? sizeRate) {
    return true;
  }
}

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

class CustomThemeSwitcher extends StatelessWidget {
  CustomThemeSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      clipper: ThemeTogglerClipper(),
      builder: (bc) {
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
            if (kDebugMode && (bc.findRenderObject()?.debugNeedsPaint ?? true)) return;
            var isDarkMode = Theme.of(bc).brightness == Brightness.dark;
            // Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            final theme = isDarkMode ? lightTheme : darkTheme;
            final switcher = ThemeSwitcher.of(bc);
            await saveThemeModePrefs(isDarkMode ? Brightness.light : Brightness.dark);
            switcher.changeTheme(theme: theme, isReversed: isDarkMode);
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [],
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
              ),
            ),
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        prefixText: "https://",
        helperText: "URI de video",
        hintText: 'Video url',
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
      fillColor: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey),
      onItemSelect: (String? value) {
        context.read<AppProvider>().setResolution(resFrmStr(value));
      },
      excludeSelected: true,
      listItemBuilder: (BuildContext context, String result) {
        return Text(
          result,
          style: context.watch<AppProvider>().resolution.resFrmEnum() == result
              ? TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
        bool? afterSave = await GallerySaver.saveImage(
          path,
          toDcim: true,
          albumName: PreferencesKeys.videoThumnails.name,
        );

        if (afterSave == null) return;

        if (!afterSave) return;
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
