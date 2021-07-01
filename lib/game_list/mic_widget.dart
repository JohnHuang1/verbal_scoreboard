import 'dart:math';

import 'package:flutter/material.dart';

class MicWidget extends StatefulWidget {
  final bool show;
  final BoxConstraints constraints;

  const MicWidget({Key key, @required this.show, @required this.constraints}) : super(key: key);

  @override
  _MicWidgetState createState() => _MicWidgetState();
}

class _MicWidgetState extends State<MicWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void didUpdateWidget(MicWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ScaleTransition(
      scale: _animation,
      child: Container(child: Icon(Icons.mic_none, size: max(widget.constraints.maxHeight, widget.constraints.maxWidth) / 100 * 20, color: Colors.white,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.primaryColor.withOpacity(0.6),
        ),
      ),
    );
  }
}
