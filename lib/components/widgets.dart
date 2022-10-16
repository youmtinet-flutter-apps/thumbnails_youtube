import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thumbnail_youtube/components/scale_transitions.dart';
import 'package:thumbnail_youtube/themes/dark_theme.dart';
import 'package:thumbnail_youtube/themes/light_theme.dart';
import 'package:thumbnail_youtube/utils/utils.dart';

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
      child: Get.isDarkMode
          ? const Icon(CupertinoIcons.moon_stars)
          : const Icon(CupertinoIcons.sun_haze),
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
            if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;

            if (!debugNeedsPaint) {
              final theme = Get.isDarkMode ? lightTheme : darkTheme;
              final switcher = ThemeSwitcher.of(bcontext);
              await savePreferences(Get.isDarkMode ? Brightness.light : Brightness.dark);
              switcher.changeTheme(theme: theme, isReversed: Get.isDarkMode);
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
          consoleLog('text${DateTime.now()}');
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
