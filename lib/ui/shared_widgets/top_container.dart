import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../core/core_constants/colors.dart';

class HomeTopContainer extends StatelessWidget {
  const HomeTopContainer({
    super.key,
    this.title,
    this.image,
    this.onMenuTap,
    this.onBellTap,
  });

  final String? title;
  final String? image;
  final VoidCallback? onMenuTap;
  final VoidCallback? onBellTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu icon
          GestureDetector(
            onTap: onMenuTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

          Gap(10.w),

          // Location pill (center, expanded)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.purple,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    title ?? 'Getting location…',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Gap(10.w),

          // Bell icon
          GestureDetector(
            onTap: onBellTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
