import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/core_constants/colors.dart';
import '../../../../app/theme.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.illustration,
  });

  final String title;
  final String subtitle;
  final Widget illustration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(16.h),

          // Illustration area
          SizedBox(
            height: 0.42.sh,
            width: double.infinity,
            child: illustration,
          ),

          Gap(32.h),

          // Title
          Text(
            title,
            style: AppThemes.getCustomTextStyle(
              fontSize: 28,
              fontFamily: 'Outfit',
              weight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 80.ms)
              .fade(begin: 0, end: 1, duration: 400.ms)
              .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut),

          Gap(12.h),

          // Subtitle
          Text(
            subtitle,
            style: AppThemes.getCustomTextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              weight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 160.ms)
              .fade(begin: 0, end: 1, duration: 400.ms)
              .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
