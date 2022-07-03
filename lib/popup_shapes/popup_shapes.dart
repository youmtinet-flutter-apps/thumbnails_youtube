library popup_shape;

import 'package:flutter/material.dart';

part 'shape_painter.dart';

enum PopupArrowPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  centerRight,
  centerLeft,
  topLeft,
  topCenter,
  topRight
}

class PopupShapes extends StatelessWidget {
  final Color bgColor;
  final Color shadowColor;
  final double shadowRadius;
  final PopupArrowPosition position;
  final Widget child;
  final double width;
  final double height;

  PopupShapes({
    Key? key,
    required this.child,
    this.bgColor = Colors.blue,
    this.shadowColor = Colors.grey,
    this.shadowRadius = 3.0,
    this.position = PopupArrowPosition.centerLeft,
    this.width = 400,
    this.height = 55,
  }) : super(key: key) {
    assert(height > 45);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: ShapePainter(
          bgColor: bgColor,
          shadowColor: shadowColor,
          shadowRadius: shadowRadius,
          position: position,
        ),
        child: Center(child: child),
      ),
    );
  }
}
