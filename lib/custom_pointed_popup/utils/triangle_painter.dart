import 'package:flutter/rendering.dart';

class TrianglePainter extends CustomPainter {
  bool isDown;
  Color color;
  TriangleDirection triangleDirection;
  TrianglePainter({
    this.isDown = true,
    required this.color,
    this.triangleDirection = TriangleDirection.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint();
    _paint.strokeWidth = 2.0;
    _paint.color = color;
    _paint.style = PaintingStyle.fill;

    Path path = Path();
    if (isDown) {
      path.moveTo(0.0, -1.0);
      path.lineTo(size.width, -1.0);
      if (triangleDirection == TriangleDirection.straight) {
        path.lineTo(size.width / 2.0, size.height);
      } else if (triangleDirection == TriangleDirection.fullLeft) {
        path.lineTo(size.width / -2.0, size.height);
      } else if (triangleDirection == TriangleDirection.left) {
        path.lineTo(size.width / 4.0, size.height);
      } else if (triangleDirection == TriangleDirection.fullRight) {
        path.lineTo(size.width / 0.5, size.height);
      } else if (triangleDirection == TriangleDirection.right) {
        path.lineTo(size.width / 1.0, size.height);
      }
    } else {
      if (triangleDirection == TriangleDirection.straight) {
        path.moveTo(size.width / 2.0, 0.0);
      } else if (triangleDirection == TriangleDirection.fullLeft) {
        path.moveTo(size.width / -2.0, 0.0);
      } else if (triangleDirection == TriangleDirection.left) {
        path.moveTo(size.width / 4.0, 0.0);
      } else if (triangleDirection == TriangleDirection.fullRight) {
        path.moveTo(size.width / 0.5, 0.0);
      } else if (triangleDirection == TriangleDirection.right) {
        path.moveTo(size.width / 1.0, 0.0);
      }

      path.lineTo(0.0, size.height + 1);
      path.lineTo(size.width, size.height + 1);
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum TriangleDirection {
  straight,
  right,
  fullRight,
  left,
  fullLeft,
}
