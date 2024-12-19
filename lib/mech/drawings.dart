import 'package:flutter/material.dart';
import 'constants.dart';

// backCircles.Draw
class DrawCircle extends CustomPainter {
  late Paint _paint;

  DrawCircle() {
    _paint = Paint()
      ..color = bShape
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 90.0, _paint); // smallCircle
    canvas.drawCircle(Offset(395.0, 350.0), 200.0, _paint); // bigCircle
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// loader.Draw
class DrawLoader extends CustomPainter {
  late Paint _paint;

  DrawLoader() {
    _paint = Paint()
      ..color = fBright
      // ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 7.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
