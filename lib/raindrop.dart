import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class RainDrop extends StatefulWidget {
  final Color color;
  final int height;
  RainDrop({required this.height, required this.color});
  @override
  _RainDropState createState() => _RainDropState();
}

class _RainDropState extends State<RainDrop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      height: widget.height * 1,
      width: 0.5,
    );
  }
}
