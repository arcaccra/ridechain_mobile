import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';

class RideArrivalLocationWidget extends StatelessWidget {
  final String? title;
  final String name;
  final IconData? iconData;
  final String timeDate;
  const RideArrivalLocationWidget({super.key, this.iconData, this.title, required this.name, required this.timeDate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on, color: AppColors.purple, size: 8),
          Gap(20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title ?? Label.destination, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 12, weight: FontWeight.w700, fontFamily: "Outfit")),
                ],
              ),
              Gap(20),
              Text(name, style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 13, weight: FontWeight.w400, fontFamily: "Outfit")),
            ],
          ),
        ],
      ),
    );
  }
}
