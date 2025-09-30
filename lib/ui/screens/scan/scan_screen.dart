import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/ui/screens/scan/widgets/top_scan_widget.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../profile/widgets/profile_top_widget.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(20.h),
                TopScanWidget()
                    .animate(delay: 100.ms)
                    .slide(
                      begin: const Offset(0, -0.3),
                      end: const Offset(0, 0), // End at center
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    )
                    .fade(begin: 0, end: 1, duration: 600.ms),
                Gap(12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
