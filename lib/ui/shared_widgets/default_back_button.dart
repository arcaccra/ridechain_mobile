import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../core/colors.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({super.key, this.onBackTap, this.iconColor, this.btnColor, this.icon, this.asset});

  final VoidCallback? onBackTap;
  final IconData? icon;
  final Color? btnColor;
  final Color? iconColor;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBackTap ?? (){
        Get.back();
      },
      child: Container(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(
            color: btnColor ?? AppColors.backgroundColor,
            shape: BoxShape.circle
        ),
        child: Center(
          child: asset == null ? Icon(
            icon ?? CupertinoIcons.arrow_left,
            color: iconColor ?? AppColors.white,
            size: 24.sp,
          ) : SvgPicture.asset(asset!, colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn), height: 24.sp, width: 24.sp,),
        ),
      ),
    );
  }
}