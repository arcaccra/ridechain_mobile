import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/colors.dart';
import '../../core/theme.dart';



class PickupDestinationWidget extends StatelessWidget {
  const PickupDestinationWidget({super.key, required this.title, this.data});

  final String title;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 146.w,
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.textFieldBorderColor)
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: AppThemes.getCustomTextStyle(fontSize: 8, color: AppColors.greyAd, weight: FontWeight.normal),),
            Text(data ?? "", style: AppThemes.getCustomTextStyle(fontSize: 10, color: AppColors.greyAd, weight: FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis,),
          ],
        ),
    );
  }
}
