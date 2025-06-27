import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ridex/core/label.dart';
import 'package:ridex/ui/shared_widgets/default_button.dart';

import '../../core/colors.dart';
import '../../core/media.dart';
import '../../core/theme.dart';


class RideSearchAndConfirmationModal extends StatelessWidget {
  const RideSearchAndConfirmationModal({super.key, this.title, this.onBtnTap, this.isSuccess = false});

  final String? title;
  final VoidCallback? onBtnTap;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 0.5.sh,
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
                colors: AppColors.gradientColors
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 160.w, width: 160.w, child: SvgPicture.asset(Media.car)),
            Text(Label.rideSearching, style: AppThemes.getCustomTextStyle(
              fontFamily: "Outfit",
              fontSize: 18,
              weight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),),
            Gap(20),
            if(isSuccess) DefaultButton(
              onBtnTap: onBtnTap!,
              btnText: Label.confirmRide,
              isIconPresent: false,
              btnColor: AppColors.primaryColor,
              btnTextColor: AppColors.white,
            ),
            if(!isSuccess) BackButton(color: AppColors.white,)
          ],
        ),
      ),
    );
  }
}
