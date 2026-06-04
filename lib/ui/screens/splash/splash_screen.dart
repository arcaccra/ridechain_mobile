import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/services/login_service.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';
import 'package:ridex/ui/screens/onboarding/onboarding_screen.dart';

import '../../../app/theme.dart';
import '../../../core/cache_helper.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/media.dart';
import '../../../providers/auth_provider.dart';
import '../landing/landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Force dark status bar icons on splash (white icons on dark bg)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    _timer = Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;

      // First time — show onboarding
      if (CacheHelper.instance.isFirstTimer != true) {
        Get.offAll(() => const OnboardingScreen());
        return;
      }

      // Returning user — check auth
      final isSignedIn = await locator<LoginService>().isUserSignedIn();
      if (!mounted) return;

      if (isSignedIn) {
        final authVm = context.read<AuthVm>();
        await authVm.fetchUserInfo();
        if (!mounted) return;
        Get.offAll(() => const AppNavigationScreen());
      } else {
        Get.offAll(() => const LandingScreen());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Restore default status bar style when leaving splash
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
      body: Stack(
        children: [
          // Radial purple glow behind the logo
          Positioned.fill(
            child: CustomPaint(painter: _RadialGlowPainter()),
          ),

          // Main content — centered
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App icon
                Image.asset(
                  Media.logo,
                  height: 80.h,
                  width: 80.h,
                )
                    .animate()
                    .fade(begin: 0, end: 1, duration: 600.ms)
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    ),

                SizedBox(height: 20.h),

                // Wordmark
                Text(
                  'Ryde',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 36,
                    weight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                )
                    .animate(delay: 200.ms)
                    .fade(begin: 0, end: 1, duration: 500.ms),

                SizedBox(height: 8.h),

                // Tagline
                Text(
                  'MOVE ON CHAIN',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    weight: FontWeight.w400,
                    color: AppColors.grey,
                    spacing: 3.0,
                  ),
                )
                    .animate(delay: 350.ms)
                    .fade(begin: 0, end: 1, duration: 500.ms),
              ],
            ),
          ),

          // Version number at bottom
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Text(
              'v 1.0.2',
              textAlign: TextAlign.center,
              style: AppThemes.getCustomTextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                weight: FontWeight.w400,
                color: AppColors.grey.withValues(alpha: 0.6),
              ),
            ).animate(delay: 400.ms).fade(begin: 0, end: 1, duration: 500.ms),
          ),
        ],
      ),
    );
  }
}

/// Paints the soft radial purple glow visible behind the logo.
class _RadialGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - size.height * 0.05);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF5500BF).withValues(alpha: 0.35),
          const Color(0xFF5500BF).withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.7));
    canvas.drawCircle(center, size.width * 0.7, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
