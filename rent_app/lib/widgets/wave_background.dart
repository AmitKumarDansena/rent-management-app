import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaveBackground extends StatefulWidget {
  final Widget child;

  const WaveBackground({
    super.key,
    required this.child,
  });

  @override
  State<WaveBackground> createState() =>
      _WaveBackgroundState();
}

class _WaveBackgroundState
    extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return CustomPaint(
                painter: BlueWavePainter(
                  animationValue: controller.value,
                ),
              );
            },
          ),
        ),

        widget.child,
      ],
    );
  }
}

class BlueWavePainter extends CustomPainter {
  final double animationValue;

  BlueWavePainter({
    required this.animationValue,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // Base blue background
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = const Color(
          0xFF1677E8,
        ),
    );

    _drawWave(
      canvas,
      size,
      0.12,
      75,
      0,
      const Color(0x332563EB),
    );

    _drawWave(
      canvas,
      size,
      0.32,
      95,
      1.8,
      const Color(0x442563EB),
    );

    _drawWave(
      canvas,
      size,
      0.72,
      90,
      3.4,
      const Color(0x4493C5FD),
    );

    _drawWave(
      canvas,
      size,
      0.88,
      70,
      5.0,
      const Color(0x557DBBF7),
    );

    // Decorative soft circles
    final circlePaint = Paint()
      ..color = const Color(
        0x1838BDF8,
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.08,
        size.height * 0.25,
      ),
      120,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.92,
        size.height * 0.58,
      ),
      150,
      circlePaint,
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double yPosition,
    double amplitude,
    double phase,
    Color color,
  ) {
    final path = Path();

    final baseY =
        size.height * yPosition;

    path.moveTo(
      0,
      baseY,
    );

    for (
      double x = 0;
      x <= size.width;
      x += 8
    ) {
      final normalized =
          x / size.width;

      final y =
          baseY +
              math.sin(
                    normalized *
                            math.pi *
                            2 +
                        phase +
                        animationValue *
                            math.pi *
                            2,
                  ) *
                  amplitude;

      path.lineTo(
        x,
        y,
      );
    }

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();

    canvas.drawPath(
      path,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(
    covariant BlueWavePainter oldDelegate,
  ) {
    return oldDelegate.animationValue !=
        animationValue;
  }
}