import 'dart:math';

import 'package:flutter/material.dart';

class MicWidget extends StatefulWidget {
  final bool show;
  final BoxConstraints constraints;

  const MicWidget({Key key, @required this.show, @required this.constraints})
      : super(key: key);

  @override
  _MicWidgetState createState() => _MicWidgetState();
}

class _MicWidgetState extends State<MicWidget>
    with TickerProviderStateMixin {
  AnimationController _showController;
  AnimationController _repeatController;
  Animation<double> _showAnimation;
  Animation<double> _repeatAnimation;

  @override
  void initState() {
    super.initState();
    _showController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _repeatController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _showAnimation = CurvedAnimation(
      parent: _showController,
      curve: Curves.easeInOut,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _repeatController.forward();
        }
      });

    _repeatAnimation = CurvedAnimation(
      parent: _repeatController,
      curve: Curves.easeInOut,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _repeatController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _repeatController.forward();
        }
      });
  }

  @override
  void didUpdateWidget(MicWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      _showController.forward();
    } else {
      _repeatController.stop();
      _showController.reverse();
    }
  }

  @override
  void dispose() {
    _showController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(_showAnimation),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.2).animate(_repeatAnimation),
        child: Container(
          child: Icon(
            Icons.mic_none,
            size:
                max(widget.constraints.maxHeight, widget.constraints.maxWidth) /
                    100 *
                    20,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.highlightColor.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
