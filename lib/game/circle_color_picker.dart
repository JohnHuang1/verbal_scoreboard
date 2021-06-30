import 'dart:math';
import 'package:flutter/material.dart';

/*
Taken from: https://github.com/Cricin/ColorPicker-flutter/blob/master/lib/color_picker.dart
 */

/// A listener which receives an color in int representation. as used
/// by [BarColorPicker.colorListener] and [CircleColorPicker.colorListener].
typedef ColorListener = void Function(int value);

/// Constant color of thumb shadow
const _kThumbShadowColor = Color(0x44000000);

/// A padding used to calculate bar height(thumbRadius * 2 - kBarPadding).
const _kBarPadding = 4;

/// Base64 encoded image for alpha picker background
const _kAlphaTexture = "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAIAAADZF8uwAAAAGUlEQVQYV2M4gwH+YwCGIasIUwhT25BVBADtzYNYrHvv4gAAAABJRU5ErkJggg==";

/// A circle palette color picker.
class CircleColorPicker extends StatefulWidget {
  // radius of the color palette, note that radius * 2 is not the final
  // width of this widget, instead is (radius + thumbRadius) * 2.
  final double radius;

  /// thumb fill color.
  final Color thumbColor;

  /// radius of thumb.
  final double thumbRadius;

  /// A listener receives color pick events.
  final ColorListener colorListener;

  /// initial color of this color picker.
  final Color initialColor;

  CircleColorPicker({
    Key key,
    this.radius = 120,
    this.initialColor = const Color(0xffff0000),
    this.thumbColor = Colors.black,
    this.thumbRadius = 8,
    @required this.colorListener
  })
      : assert (radius != null),
        assert(thumbColor != null),
        assert(colorListener != null),
        super(key: key);


  @override
  State<CircleColorPicker> createState() {
    return _CircleColorPickerState();
  }
}

class _CircleColorPickerState extends State<CircleColorPicker> {
  static const List<Color> colors = [
    Color(0xffff0000),
    Color(0xffffff00),
    Color(0xff00ff00),
    Color(0xff00ffff),
    Color(0xff0000ff),
    Color(0xffff00ff),
    Color(0xffff0000)
  ];

  double thumbDistanceToCenter;
  double thumbRadians;

  @override
  void initState() {
    super.initState();
    thumbDistanceToCenter = widget.radius;
    final double hue = HSVColor
        .fromColor(widget.initialColor)
        .hue;
    thumbRadians = degreesToRadians(270 - hue);
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.radius;
    final double thumbRadius = widget.thumbRadius;

    // compute thumb center coordinate
    final double thumbCenterX = radius +
        thumbDistanceToCenter * sin(thumbRadians);
    final double thumbCenterY = radius +
        thumbDistanceToCenter * cos(thumbRadians);

    // build thumb widget
    Widget thumb = Positioned(
        left: thumbCenterX,
        top: thumbCenterY,
        child: Container(
          width: thumbRadius * 2,
          height: thumbRadius * 2,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: _kThumbShadowColor,
                  spreadRadius: 2,
                  blurRadius: 3,
                )
              ],
              color: widget.thumbColor,
              borderRadius: BorderRadius.all(Radius.circular(thumbRadius))
          ),
        )
    );
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (details) => handleTouch(details.globalPosition, context),
        onPanStart: (details) => handleTouch(details.globalPosition, context),
        onPanUpdate: (details) => handleTouch(details.globalPosition, context),
        child: Stack(
          children: <Widget>[
            SizedBox(
                width: (radius + thumbRadius) * 2,
                height: (radius + thumbRadius) * 2
            ),
            Positioned(
              left: thumbRadius,
              top: thumbRadius,
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                    gradient: SweepGradient(colors: colors)
                ),
              ),
            ),
            thumb
          ],
        )
    );
  }

  /// calculate colors picked from palette and update our states.
  void handleTouch(Offset globalPosition, BuildContext context) {
    RenderBox box = context.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);
    final double centerX = box.size.width / 2;
    final double centerY = box.size.height / 2;
    final double deltaX = localPosition.dx - centerX;
    final double deltaY = localPosition.dy - centerY;
    final double distanceToCenter = sqrt(deltaX * deltaX + deltaY * deltaY);
    double theta = atan2(deltaX, deltaY);
    double degree = 270 - radiansToDegrees(theta);
    if (degree < 0) degree = 360 + degree;
    widget.colorListener(HSVColor
        .fromAHSV(1, degree, 1, 1)
        .toColor()
        .value);
    setState(() {
      thumbDistanceToCenter = min(distanceToCenter, widget.radius);
      thumbRadians = theta;
    });
  }

  /// convert an angle value from radian to degree representation.
  double radiansToDegrees(double radians) {
    return (radians + pi) / pi * 180;
  }

  /// convert an angle value from degree to radian representation.
  double degreesToRadians(double degrees) {
    return degrees / 180 * pi - pi;
  }
}