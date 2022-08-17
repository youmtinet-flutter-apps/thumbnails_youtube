library custom_pointed_popup;

import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'utils/triangle_painter.dart';

///Custom Pointed Popup Item
class CustomPointedPopupItem {
  Widget? iconWidget;
  String? title;
  TextStyle? textStyle;
  TextAlign? textAlign;

  ///Adding this would replace the popup default item to item widget.
  Widget? itemWidget;

  CustomPointedPopupItem({
    this.title,
    this.iconWidget,
    this.textStyle,
    this.textAlign,
    this.itemWidget,
  }) : assert(title != null || itemWidget != null);

  Widget? get getIconWidget => iconWidget;

  Widget? get getItemWidget => itemWidget;

  String? get getTitle => title;

  TextStyle get getTextStyle {
    const textStyle1 = TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0);
    return textStyle ?? textStyle1;
  }

  TextAlign get getTextAlign => textAlign ?? TextAlign.center;
}

typedef WidgetClickCallBack = Function(CustomPointedPopupItem item);
typedef CustomPopupStateChanged = Function(bool isShow);

///Custom Pointed Popup
class CustomPointedPopup {
  static var itemWidth = 72.0;
  static var itemHeight = 65.0;
  static var arrowHeight = 10.0;
  late OverlayEntry _entry;
  late CustomPointedPopupItem item;

  /// row count
  late int _row;

  /// col count
  late int _col;

  /// The left top point of this popup.
  late Offset _offset;

  /// Popup will show at above or under this rect
  late Rect _showRect;

  /// calculated automatically: if false popup is show above of the widget, otherwise popup is show under the widget
  bool _isTriangleDown = true;

  /// The max column count, default is 4.
  late int _widthFractionWithRespectToDeviceWidth;

  /// callback
  late VoidCallback? dismissCallback;
  late WidgetClickCallBack? onClickItemWidget;
  late CustomPopupStateChanged? stateChanged;

  late Size _screenSize;

  /// Cannot be null
  BuildContext context;

  /// style
  late Color _backgroundColor;

  /// It's showing or not.
  bool _isShow = false;
  bool get isShow => _isShow;

  ///always displayed popup below the widget.
  bool displayBelowWidget;
  double? customHeight;

  TriangleDirection? triangleDirection;

  BorderRadius? popupBorderRadius;

  double? popupElevation;

  CustomPointedPopup({
    WidgetClickCallBack? onClickWidget,
    required this.context,
    VoidCallback? onDismiss,
    int? widthFractionWithRespectToDeviceWidth,
    Color? backgroundColor,
    CustomPopupStateChanged? stateChangeed,
    required this.item,
    this.displayBelowWidget = false,
    this.triangleDirection,
    this.popupBorderRadius,
    this.popupElevation,
    this.customHeight,
  }) {
    onClickItemWidget = onClickWidget;
    dismissCallback = onDismiss;
    stateChanged = stateChangeed;
    _widthFractionWithRespectToDeviceWidth =
        widthFractionWithRespectToDeviceWidth ?? 3;
    _backgroundColor = backgroundColor ?? Colors.red;
  }

  void show({Rect? rect, GlobalKey? widgetKey, CustomPointedPopupItem? item}) {
    assert(rect != null || widgetKey != null);
    if (rect == null && widgetKey == null) {
      throw ErrorWidget.withDetails(
        message: 'Both Rect & Widget key can\'t be null.',
      );
    }

    this.item = item ?? this.item;
    _showRect = rect ?? CustomPointedPopup.getWidgetGlobalRect(widgetKey!);
    _screenSize = window.physicalSize / window.devicePixelRatio;
    dismissCallback = dismissCallback;

    _calculatePosition(context);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });

    Overlay.of(context)!.insert(_entry);
    _isShow = true;
    if (stateChanged != null) {
      stateChanged!(true);
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject()! as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _col = _calculateColCount();
    _row = _calculateRowCount();
    _offset = _calculateOffset(context);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - popupWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + popupWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - popupWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - (customHeight ?? popupHeight());

    if (displayBelowWidget) {
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isTriangleDown = false;
    } else {
      if (dy <= MediaQuery.of(context).padding.top + 10) {
        dy = arrowHeight + _showRect.height + _showRect.top;
        _isTriangleDown = false;
      } else {
        dy -= arrowHeight;
        _isTriangleDown = true;
      }
    }

    return Offset(dx, dy);
  }

  double popupWidth() {
    return itemWidth * _col;
  }

  double popupHeight() {
    var height = itemHeight * _row;
    return height;
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
        onVerticalDragStart: (DragStartDetails details) {
          dismiss();
        },
        onHorizontalDragStart: (DragStartDetails details) {
          dismiss();
        },
        child: Stack(
          children: <Widget>[
            // Triangle arrow paint
            Positioned(
              left: _showRect.left + _showRect.width / 2.0 - 7.5,
              top: _isTriangleDown
                  ? offset.dy + (customHeight ?? popupHeight())
                  : (offset.dy - arrowHeight),
              child: CustomPaint(
                size: Size(15.0, arrowHeight),
                painter: TrianglePainter(
                  isDown: _isTriangleDown,
                  color: _backgroundColor,
                  triangleDirection: triangleDirection != null
                      ? triangleDirection!
                      : TriangleDirection.straight,
                ),
              ),
            ),
            // Widgets
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Card(
                elevation: popupElevation ?? 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      popupBorderRadius ?? BorderRadius.circular(10.0),
                ),
                child: SizedBox(
                  width: popupWidth(),
                  height: displayBelowWidget
                      ? customHeight
                      : (customHeight ?? popupHeight()),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            popupBorderRadius ?? BorderRadius.circular(10.0),
                        child: Container(
                          width: popupWidth(),
                          height: displayBelowWidget
                              ? customHeight
                              : (customHeight ?? popupHeight()),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: _backgroundColor,
                            borderRadius: popupBorderRadius ??
                                BorderRadius.circular(10.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              itemClicked(item);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: item.itemWidget != null
                                  ? [item.itemWidget!]
                                  : [
                                      item.getIconWidget!,
                                      Text(
                                        '${item.getTitle}',
                                        style: item.getTextStyle,
                                        textAlign: item.getTextAlign,
                                        overflow: displayBelowWidget
                                            ? TextOverflow.clip
                                            : TextOverflow.ellipsis,
                                      ),
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  int _calculateRowCount() {
    int itemCount = 1;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  int _calculateColCount() {
    if (_widthFractionWithRespectToDeviceWidth >= 5) {
      return 4;
    }

    return _widthFractionWithRespectToDeviceWidth;
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  void itemClicked(CustomPointedPopupItem item) {
    if (onClickItemWidget != null) {
      onClickItemWidget!(item);
    }

    dismiss();
  }

  void dismiss() {
    if (!_isShow) {
      return;
    }

    _entry.remove();
    _isShow = false;
    if (dismissCallback != null) {
      dismissCallback!();
    }

    if (stateChanged != null) {
      stateChanged!(false);
    }
  }
}
