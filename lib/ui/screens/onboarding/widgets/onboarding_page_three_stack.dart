import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/core_constants/colors.dart';
import '../../../../app/theme.dart';

/// Slide 3 — "Verified rides, real rewards"
/// Lavender circle with a QR code card, scan line, green checkmark, and +0.05 ₳ reward.
class OnBoardingPageThreeStack extends StatelessWidget {
  const OnBoardingPageThreeStack({super.key});

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
                .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOut),

            // QR card + checkmark + reward label
            Positioned(
              top: 48,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // QR card with green checkmark overlay
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // QR card
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: CustomPaint(painter: _QrCodePainter()),
                      )
                          .animate(delay: 150.ms)
                          .fade(begin: 0, end: 1, duration: 400.ms)
                          .scale(
                              begin: const Offset(0.85, 0.85),
                              end: const Offset(1, 1),
                              duration: 400.ms,
                              curve: Curves.easeOut),

                      // Purple scan line
                      Positioned(
                        top: 72,
                        left: 12,
                        right: 12,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.purple,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ).animate(delay: 350.ms).fade(
                            begin: 0, end: 1, duration: 300.ms),
                      ),

                      // Green checkmark circle
                      Positioned(
                        bottom: -14,
                        right: -14,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF22C55E),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        )
                            .animate(delay: 450.ms)
                            .fade(begin: 0, end: 1, duration: 350.ms)
                            .scale(
                                begin: const Offset(0.4, 0.4),
                                end: const Offset(1, 1),
                                duration: 350.ms,
                                curve: Curves.easeOutBack),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // +0.05 ₳ reward label
                  Text(
                    '+0.05 ₳',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      weight: FontWeight.w700,
                      color: AppColors.purple,
                    ),
                  )
                      .animate(delay: 500.ms)
                      .fade(begin: 0, end: 1, duration: 350.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws a simplified but recognisable QR code pattern.
class _QrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dark = Paint()..color = const Color(0xFF111111);
    final s = size.width / 10; // cell size

    // Top-left finder
    _drawFinder(canvas, dark, 0, 0, s);
    // Top-right finder
    _drawFinder(canvas, dark, size.width - 7 * s, 0, s);
    // Bottom-left finder
    _drawFinder(canvas, dark, 0, size.height - 7 * s, s);

    // Some scattered data modules to simulate QR
    final cells = [
      [7, 0], [8, 0], [9, 0],
      [7, 1],
      [8, 2], [9, 2],
      [7, 3], [9, 3],
      [0, 7], [1, 7], [3, 7],
      [0, 8], [2, 8],
      [1, 9], [3, 9],
      [4, 4], [5, 5], [6, 6],
      [4, 6], [6, 4],
      [5, 7], [7, 5],
      [8, 7], [9, 8],
      [7, 9], [9, 9],
    ];
    for (final cell in cells) {
      canvas.drawRect(
        Rect.fromLTWH(cell[0] * s, cell[1] * s, s * 0.85, s * 0.85),
        dark,
      );
    }
  }

  void _drawFinder(Canvas canvas, Paint dark, double x, double y, double s) {
    // Outer 7×7 square
    canvas.drawRect(
      Rect.fromLTWH(x, y, 7 * s, 7 * s),
      Paint()..color = const Color(0xFF111111),
    );
    // White inner 5×5
    canvas.drawRect(
      Rect.fromLTWH(x + s, y + s, 5 * s, 5 * s),
      Paint()..color = Colors.white,
    );
    // Dark inner 3×3
    canvas.drawRect(
      Rect.fromLTWH(x + 2 * s, y + 2 * s, 3 * s, 3 * s),
      Paint()..color = const Color(0xFF111111),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
