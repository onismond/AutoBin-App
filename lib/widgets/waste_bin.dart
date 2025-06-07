import 'package:flutter/material.dart';

class WasteBinWidget extends StatefulWidget {
  final double fillLevel; // 0.0 to 1.0
  final double width;
  final double height;

  const WasteBinWidget({
    Key? key,
    required this.fillLevel,
    this.width = 100,
    this.height = 200,
  }) : super(key: key);

  @override
  State<WasteBinWidget> createState() => _WasteBinWidgetState();
}

class _WasteBinWidgetState extends State<WasteBinWidget> {
  double _animatedFillLevel = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        _animatedFillLevel = widget.fillLevel.clamp(0.0, 1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: _animatedFillLevel),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, fillLevel, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.width, widget.height),
                painter: SimpleBinPainter(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: widget.width * 0.92,
                  height: widget.height * fillLevel,
                  decoration: BoxDecoration(
                    color: fillLevel > 0.8
                        ? Colors.red
                        : fillLevel > 0.5
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
              ),
              Positioned(
                child: Text(
                  "${(fillLevel * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 3,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class SimpleBinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final double margin = size.width * 0.05;
    final double left = margin;
    final double right = size.width - margin;
    final double bottom = size.height;

    final double handleWidth = size.width * 0.2;
    final double handleHeight = size.height * 0.03;

    // Extended top line length (extends 10% of width on both sides)
    final double topLineExtension = size.width * 0.1;
    final double extendedLeft = left - topLineExtension;
    final double extendedRight = right + topLineExtension;

    final path = Path()
    // Bin sides and bottom
      ..moveTo(left, 0)
      ..lineTo(left, bottom)
      ..lineTo(right, bottom)
      ..lineTo(right, 0)

    // Extended top line
      ..moveTo(extendedLeft, 0)
      ..lineTo(extendedRight, 0);

    canvas.drawPath(path, paint);

    // Handle (small notch above the top)
    final double handleLeft = (size.width - handleWidth) / 2;
    final handleRect = Rect.fromLTWH(
      handleLeft,
      -handleHeight - 2, // slightly above the top line
      handleWidth,
      handleHeight,
    );

    final handlePaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    canvas.drawRect(handleRect, handlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


