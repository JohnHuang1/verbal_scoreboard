import 'dart:math';

import 'package:flutter/material.dart';

class JarvisWidget extends StatefulWidget {
  final bool show;
  final bool hide;
  final BoxConstraints constraints;

  const JarvisWidget(
      {Key key,
      @required this.show,
      @required this.hide,
      @required this.constraints})
      : super(key: key);

  @override
  _JarvisWidgetState createState() => _JarvisWidgetState();
}

class _JarvisWidgetState extends State<JarvisWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _hideController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _hideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void didUpdateWidget(covariant JarvisWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    if (widget.hide) {
      _hideController.forward();
    } else {
      _hideController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(
        begin: Offset(0.0, -4.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: _hideController,
            curve: Curves.easeInOut,
          ),
        ),
        child: Container(
          width: widget.constraints.maxWidth / 2,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Jarvis Activated",
                style: TextStyle(color: Colors.black),
              )),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).highlightColor.withOpacity(0.8),
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          margin: EdgeInsets.all(20),
        ),
      ),
    );
  }
}
