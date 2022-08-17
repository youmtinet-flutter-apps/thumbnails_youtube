import 'package:flutter/material.dart';
import 'package:thumbnail_youtube/anchored_popups/anchored_popup_region.dart';
import 'package:thumbnail_youtube/anchored_popups/anchored_popups.dart';

class ClickToggle extends StatefulWidget {
  const ClickToggle({
    Key? key,
  }) : super(key: key);

  @override
  State<ClickToggle> createState() => _ClickToggleState();
}

class _ClickToggleState extends State<ClickToggle> {
  @override
  Widget build(BuildContext context) {
    return AnchoredPopUpRegion(
      mode: PopUpMode.clickToToggle,
      anchor: Alignment.topCenter,
      popAnchor: Alignment.topCenter,
      barrierDismissable: false,
      // This is what is shown when the popup is opened:
      popChild: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("TapTo Toggle"),
            TextButton(
              onPressed: () {
                AnchoredPopups.of(context)!.hide();
              },
              child: const Text("Close Popup"),
            )
          ],
        ),
      ),
      // The region that will activate the popup
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Click me for more info..."),
        ),
      ),
    );
  }
}

class Corner extends StatelessWidget {
  const Corner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnchoredPopUpRegion(
      mode: PopUpMode.clickToToggle,
      anchor: Alignment.centerLeft,
      popAnchor: Alignment.topRight,
      popChild: Card(
        child: Text("Pop Child"),
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Placeholder(),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnchoredPopUpRegion(
      mode: PopUpMode.clickToToggle,
      anchor: Alignment.bottomLeft,
      popAnchor: Alignment.bottomRight,
      popChild: Card(
        child: Text("BottomLeft to BottomRight"),
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Placeholder(),
      ),
    );
  }
}

class NewWidget1 extends StatelessWidget {
  const NewWidget1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnchoredPopUpRegion(
      mode: PopUpMode.clickToToggle,
      anchor: Alignment.center,
      popAnchor: Alignment.center,
      popChild: Card(
        child: Text("Center to Center"),
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Placeholder(strokeWidth: 5),
      ),
    );
  }
}
