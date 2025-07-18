import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ridex/core/core_constants/label.dart';
import 'package:ridex/ui/screens/onboarding/onboarding_screen.dart';

import '../../../core/cache_helper.dart';
import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/media.dart';
import '../auth/login_screen.dart';

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
    _handleLogin();
  }

  _handleLogin() async {
    _timer = Timer(const Duration(seconds: 2), () {
      if (CacheHelper.instance.isFirstTimer == true) {
        Get.offAll(() => const LoginScreen());
      } else {
        Get.offAll(() => const OnboardingScreen());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 1.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [0.25, 1],
                colors: [
              AppColors.purple,
              AppColors.primaryColor
            ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Media.logo,
                height: 130.h,
                width: 130.h,
              )
                  .animate()
                  .slide(
                begin: const Offset(0, -0.2), // Start from top of screen
                end: const Offset(0, 0), // End at center
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutBack,
              )
                  .fade(begin: 0, end: 1, duration: 500.ms),
              // Text(Label.appNameLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 29.94))
              //     .animate(delay: 200.ms)
              //     .slide(
              //       begin: const Offset(0, -0.3), // Start from top of screen
              //       end: const Offset(0, 0), // End at center
              //       duration: const Duration(seconds: 1),
              //       curve: Curves.easeOutBack,
              //     )
              //     .fade(begin: 0, end: 1, duration: 500.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
