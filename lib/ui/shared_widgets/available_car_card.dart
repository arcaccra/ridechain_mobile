import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../core/colors.dart';
import '../../core/label.dart';
import '../../core/media.dart';
import '../../core/theme.dart';


class AvailableCarCard extends StatelessWidget {
  const AvailableCarCard({super.key, this.amount, this.minutes, this.rating});

  final double? amount;
  final int? minutes;
  final double? rating;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 137.w,
      height: 139.h,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: AppColors.textFieldBorderColor)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 7, width:8, child: Icon(Icons.star, color: AppColors.yellow, size: 7,)),
              Text("${rating ?? 4.5}/5", style: AppThemes.getCustomTextStyle(fontSize: 8, color: AppColors.greyAd, weight: FontWeight.w400),),
            ],
          ),
          Gap(10),
          SizedBox(height: 47, width: 99, child: Image.asset(Media.onboardingToyotaImg, height: 47, width: 99,)),
          Gap(16),
          Text("${Label.ada} ${amount ?? ""}", style: AppThemes.getCustomTextStyle(fontSize: 16, color: AppColors.primaryColor, weight: FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis,),
          Gap(16),
          Text("${minutes ?? 7} min", style: AppThemes.getCustomTextStyle(fontSize: 8, color: AppColors.greyAd, weight: FontWeight.w400),),
        ],
      ),
    );
  }
}
