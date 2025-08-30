 

import 'package:flutter/material.dart';

class DrawTextDottedAnimation extends StatefulWidget {
  const DrawTextDottedAnimation({super.key});

  @override
  State<DrawTextDottedAnimation> createState() =>
      _DrawTextDottedAnimationState();
}

class _DrawTextDottedAnimationState extends State<DrawTextDottedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: DottedTextPainter(progress: _controller.value),
            size: const Size(300, 100),
          );
        },
      ),
    );
  }
}

class DottedTextPainter extends CustomPainter {
  final double progress;

  DottedTextPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const text = 'DRAW';
    const fontSize = 60.0;

    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      foreground:
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.amber,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);

    // Create path for stroke outlines
    textPainter.text!.toPlainText().runes.forEach((int rune) {});

    // Draw animated dotted line
    final paint =
        Paint()
          ..color = Colors.amber
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    // Simplified version: draw circles along the letters
    final step = 10.0;
    for (double i = progress * step; i < textPainter.width; i += step) {
      canvas.drawCircle(
        Offset(offset.dx + i, offset.dy + fontSize / 2),
        2,
        paint,
      ); // top line
      canvas.drawCircle(
        Offset(offset.dx + i, offset.dy + fontSize / 2 + 6),
        2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
