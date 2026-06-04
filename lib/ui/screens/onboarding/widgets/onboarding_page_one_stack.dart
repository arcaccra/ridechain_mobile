import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/media.dart';

/// Slide 1 — "Carpool, on your terms"
/// Lavender circle with a car SVG, dashed route arc, and origin/destination dots.
class OnboardingPageOneStack extends StatelessWidget {
  const OnboardingPageOneStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lavender background circle
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEDE8FA),
              ),
            )
                .animate()
                .fade(begin: 0, end: 1, duration: 500.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 500.ms, curve: Curves.easeOut),

            // Dashed arc + origin/destination dots
            Positioned.fill(
              child: CustomPaint(painter: _RouteArcPainter()),
            ),

            // Car SVG — slightly above center
            Positioned(
              top: 60,
              child: SvgPicture.asset(
                Media.car,
                height: 72,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1A0A2E),
                  BlendMode.srcIn,
                ),
              )
                  .animate(delay: 200.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms)
                  .slideY(begin: -0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2;

    // Origin dot (purple) — left edge of circle, vertically centered
    final originX = cx - radius * 0.78;
    final originY = cy + radius * 0.12;

    // Destination dot (red) — right edge of circle, vertically centered
    final destX = cx + radius * 0.78;
    final destY = cy + radius * 0.12;

    // Control point for arc (above the endpoints)
    final arcControlY = originY - radius * 0.45;

    final arcPath = Path()
      ..moveTo(originX, originY)
      ..quadraticBezierTo(cx, arcControlY, destX, destY);

    // Dashed stroke
    final dashedPaint = Paint()
      ..color = AppColors.purple
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, arcPath, dashedPaint, dashLength: 8, gapLength: 6);

    // Origin dot — purple
    canvas.drawCircle(
      Offset(originX, originY),
      10,
      Paint()..color = AppColors.purple,
    );

    // Destination dot — red
    canvas.drawCircle(
      Offset(destX, destY),
      10,
      Paint()..color = const Color(0xFFEF4444),
    );
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashLength,
    required double gapLength,
  }) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      bool drawing = true;
      while (distance < metric.length) {
        final len = drawing ? dashLength : gapLength;
        if (drawing) {
          canvas.drawPath(
            metric.extractPath(distance, min(distance + len, metric.length)),
            paint,
          );
        }
        distance += len;
        drawing = !drawing;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
