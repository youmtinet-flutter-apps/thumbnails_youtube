import 'package:thumbnail_youtube/anchored_popups/example_widgets/click_toggle.dart';

import 'anchored_popups.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const AnchoredPopups(
      child: MaterialApp(
        home: PopupTests(),
      ),
    );
  }
}

class PopupTests extends StatelessWidget {
  const PopupTests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            bottom: 0,
            right: 0,
            child: Corner(),
          ),
          Center(
            child: SeparatedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              separatorBuilder: () => const SizedBox(height: 10),
              children: const [
                Text("Hover over the boxes to show different behaviors."),
                NewWidget1(),
                NewWidget(),
                ClickToggle(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
