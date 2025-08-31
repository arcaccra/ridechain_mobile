import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ridex/core/core_constants/label.dart';
import 'package:ridex/ui/shared_widgets/default_back_button.dart';
import 'package:ridex/ui/shared_widgets/default_button.dart';

import '../../core/core_constants/colors.dart';
import '../../core/core_constants/media.dart';
import '../../app/theme.dart';


class RideSearchingLoader extends StatelessWidget {
  const RideSearchingLoader({super.key, this.title, this.onBtnTap, this.notLoadingState = false, this.lowerBtnText});

  final String? title;
  final String? lowerBtnText;
  final VoidCallback? onBtnTap;
  final bool notLoadingState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 0.5.sh,
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            // gradient: LinearGradient(
            //     colors: AppColors.gradientColors
            // )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 160.w, width: 160.w, child: SvgPicture.asset(Media.car)),
            Text(title ?? Label.rideSearching, style: AppThemes.getCustomTextStyle(
              fontFamily: "Outfit",
              fontSize: 18,
              weight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),),
            Gap(30.h),
            if(notLoadingState) DefaultButton(
              onBtnTap: onBtnTap!,
              btnText: Label.confirmRide,
              isIconPresent: false,
              btnColor: AppColors.primaryColor,
              btnTextColor: AppColors.white,
            ),
            if(!notLoadingState) DefaultBackButton(
              onBackTap: onBtnTap,
              btnColor: AppColors.primaryColor,
              icon: Icons.clear,
              iconColor: AppColors.white,
            ),
            Gap(!notLoadingState ? 16 : 0),
            if(!notLoadingState) Text(lowerBtnText ?? Label.buttonCancelText, style: AppThemes.getCustomTextStyle(
              fontFamily: "Inter",
              fontSize: 12,
              weight: FontWeight.w400,
              color: AppColors.primaryColor,)),
            Gap(!notLoadingState ? 16 : 0),
            if(!notLoadingState) SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 0.4,
              ),
            )
          ],
        ),
      ),
    );
  }
}
