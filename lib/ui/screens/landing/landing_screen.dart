import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ridex/core/core_constants/colors.dart';

import '../../../app/theme.dart';
import '../../shared_widgets/default_button.dart';
import '../auth/login_screen.dart';
import '../auth/register.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // App illustration
              Expanded(
                child: Center(
                  child: _LandingIllustration()
                      .animate()
                      .fade(begin: 0, end: 1, duration: 600.ms)
                      .scale(
                          begin: const Offset(0.92, 0.92),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.easeOut),
                ),
              ),

              SizedBox(height: 32.h),

              // Brand badge row
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'R',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        weight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Ryde',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      weight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              )
                  .animate(delay: 100.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms),

              SizedBox(height: 16.h),

              // Headline
              RichText(
                text: TextSpan(
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 44,
                    weight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  children: [
                    const TextSpan(text: 'Your ride.\nYour wallet.\n'),
                    TextSpan(
                      text: 'On chain.',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 44,
                        weight: FontWeight.w700,
                        color: AppColors.purple,
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 180.ms)
                  .fade(begin: 0, end: 1, duration: 450.ms)
                  .slideY(begin: 0.1, end: 0, duration: 450.ms, curve: Curves.easeOut),

              SizedBox(height: 12.h),

              // Subtitle
              Text(
                'Carpool across the city. Pay in ADA. Skip the surge.',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  weight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
              )
                  .animate(delay: 260.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms),

              SizedBox(height: 32.h),

              // Create account button
              DefaultButton(
                onBtnTap: () => Get.to(() => const Register()),
                btnText: 'Create account',
                btnColor: AppColors.purple,
                btnTextColor: AppColors.white,
              )
                  .animate(delay: 320.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut),

              SizedBox(height: 12.h),

              // Sign in button
              DefaultButton(
                onBtnTap: () => Get.to(() => const LoginScreen()),
                btnText: 'Sign in',
                btnColor: const Color(0xFF1C1C30),
                btnTextColor: AppColors.white,
              )
                  .animate(delay: 380.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stylised illustration of a map UI with route line, fare tag, and driver rating.
class _LandingIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main dark frame (map area)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16162A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomPaint(painter: _MapGridPainter()),
              ),
            ),
          ),

          // Route line with red dot
          Positioned.fill(
            child: CustomPaint(painter: _RouteLinePainter()),
          ),

          // Ride detail card (bottom portion of the map frame)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purple.withValues(alpha: 0.15),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 70,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 72,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // "2.5 ₳/seat" price chip — overlaps top-left of frame
          Positioned(
            top: 40,
            left: -12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '2.5 ₳/seat',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  weight: FontWeight.w600,
                  color: const Color(0xFF111111),
                ),
              ),
            ),
          ),

          // "★ 4.9 driver" rating chip — overlaps bottom-right of frame
          Positioned(
            bottom: 90,
            right: -8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '★ 4.9 driver',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle grid lines to simulate a dark map background.
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2A44)
      ..strokeWidth = 1;

    const cols = 4;
    const rows = 4;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    for (var i = 1; i < cols; i++) {
      canvas.drawLine(
          Offset(i * cellW, 0), Offset(i * cellW, size.height), paint);
    }
    for (var j = 1; j < rows; j++) {
      canvas.drawLine(
          Offset(0, j * cellH), Offset(size.width, j * cellH), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Purple route line from bottom-left toward a red destination dot at top-right.
class _RouteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final startX = size.width * 0.15;
    final startY = size.height * 0.85;
    final endX = size.width * 0.72;
    final endY = size.height * 0.18;

    final linePaint = Paint()
      ..color = AppColors.purple
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);

    // Red destination dot
    canvas.drawCircle(
      Offset(endX, endY),
      8,
      Paint()..color = const Color(0xFFEF4444),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
