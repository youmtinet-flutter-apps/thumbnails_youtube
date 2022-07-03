import 'anchored_popup_region.dart';
import 'anchored_popups.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
            child: AnchoredPopUpRegion(
              anchor: Alignment.centerLeft,
              popAnchor: Alignment.centerRight,
              popChild: Card(child: Text("centerLeft to centerRight")),
              child: SizedBox(
                width: 50,
                height: 50,
                child: Placeholder(),
              ),
            ),
          ),
          Center(
            child: SeparatedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              separatorBuilder: () => const SizedBox(height: 10),
              children: [
                const Text("Hover over the boxes to show different behaviors."),
                const AnchoredPopUpRegion(
                  anchor: Alignment.bottomLeft,
                  popAnchor: Alignment.bottomRight,
                  popChild: Card(child: Text("BottomLeft to BottomRight")),
                  child: SizedBox(width: 50, height: 50, child: Placeholder()),
                ),

                const AnchoredPopUpRegion(
                  anchor: Alignment.center,
                  popAnchor: Alignment.center,
                  popChild: Card(child: Text("Center to Center")),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Placeholder(),
                  ),
                ),

                /// Example of a card that, when clicked shows a form.
                AnchoredPopUpRegion(
                  mode: PopUpMode.clickToToggle,
                  anchor: Alignment.centerRight,
                  popAnchor: Alignment.centerLeft,
                  // This is what is shown when the popup is opened:
                  popChild: Card(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("CenterRight to CenterLeft"),
                      TextButton(
                          onPressed: () {
                            AnchoredPopups.of(context)!.hide();
                          },
                          child: const Text("Close Popup"))
                    ],
                  )),
                  // The region that will activate the popup
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Click me for more info..."),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
