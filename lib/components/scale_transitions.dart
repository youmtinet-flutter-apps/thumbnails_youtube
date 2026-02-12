import 'package:flutter/material.dart';

class ButtonScaleTransition extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scaleFactor;
  final Duration duration;
  final bool stayOnBottom;
  ButtonScaleTransition({Key? key, required this.child, required this.onPressed, this.scaleFactor = 2, this.duration = const Duration(milliseconds: 80), this.stayOnBottom = false}) : super(key: key);

  @override
  _ButtonScaleTransitionState createState() => _ButtonScaleTransitionState();
}

class _ButtonScaleTransitionState extends State<ButtonScaleTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late double _scale;

  final GlobalKey _childKey = GlobalKey();

  bool _isOutside = false;

  Widget get child => widget.child;

  VoidCallback get onPressed => widget.onPressed;

  double get scaleFactor => widget.scaleFactor;

  Duration get duration => widget.duration;

  bool get _stayOnBottom => widget.stayOnBottom;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: duration, lowerBound: 0.0, upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void didUpdateWidget(ButtonScaleTransition oldWidget) {
    if (oldWidget.stayOnBottom != _stayOnBottom) {
      if (!_stayOnBottom) {
        _reverseAnimation();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - (_controller.value * scaleFactor);
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onLongPressEnd: (LongPressEndDetails details) => _onLongPressEnd(details, context),
      onHorizontalDragEnd: _onDragEnd,
      onVerticalDragEnd: _onDragEnd,
      onHorizontalDragUpdate: (DragUpdateDetails details) => _onDragUpdate(details, context),
      onVerticalDragUpdate: (DragUpdateDetails details) => _onDragUpdate(details, context),
      child: Transform.scale(key: _childKey, scale: _scale, child: child),
    );
  }

  void _triggerOnPressed() {
    onPressed();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!_stayOnBottom) {
      Future<void>.delayed(duration, () {
        _reverseAnimation();
      });
    }

    _triggerOnPressed();
  }

  void _onDragUpdate(DragUpdateDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;
    _isOutside = _isOutsideChildBox(touchPosition);
  }

  void _onLongPressEnd(LongPressEndDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;

    if (!_isOutsideChildBox(touchPosition)) {
      _triggerOnPressed();
    }

    _reverseAnimation();
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isOutside) {
      _triggerOnPressed();
    }
    _reverseAnimation();
  }

  void _reverseAnimation() {
    if (mounted) {
      _controller.reverse();
    }
  }

  bool _isOutsideChildBox(Offset touchPosition) {
    final RenderBox? childRenderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (childRenderBox == null) {
      return true;
    }
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return (touchPosition.dx < childPosition.dx || touchPosition.dx > childPosition.dx + childSize.width || touchPosition.dy < childPosition.dy || touchPosition.dy > childPosition.dy + childSize.height);
  }
}
