import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ridex/app/theme.dart';

import '../../core/core_constants/colors.dart';
import '../../core/core_constants/media.dart';



class HomeTopContainer extends StatelessWidget {
  const HomeTopContainer({super.key, this.title, this.image});

  final String? title;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 299.h,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.11),
            spreadRadius: 0,
            blurRadius: 16.8,
            offset: Offset(0, 4.5),)
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(title != null ? Media.marker : Media.blackCar, width: 21, height: 21, colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn),),
          Gap(8.w),
          Flexible(
            child: Text(
              title ?? "Welcome to RideShare.",
              style: AppThemes.getCustomTextStyle(
                fontSize: 13
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    ).animate().scale(
      delay: 200.ms,
      duration: 500.ms,
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1), // 10% size increase
      curve: Curves.easeOut,
    );
  }
}
