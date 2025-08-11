import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../app/theme.dart';
import '../../core/core_constants/colors.dart';
import '../../core/core_constants/label.dart';
import '../../core/core_constants/media.dart';


class AcceptedTripDetailWidget extends StatelessWidget {
  const AcceptedTripDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=3',
              ),
            ),
            Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("John Doe", style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 18, weight: FontWeight.w700, color: AppColors.black)),
                  Gap(8),
                  Row(
                    children: [
                      SvgPicture.asset(Media.steering, height: 12, width: 12),
                      Gap(4),
                      Text("Hyundai Elantra (Silver)", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w400),),
                      Gap(16),
                      SvgPicture.asset(Media.blackCar, height: 12, width: 12),
                      Gap(4),
                      Text("MNO-7890", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w700),),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text("ADA 28.50", style: AppThemes.getCustomTextStyle(fontSize: 18, fontFamily: "Outfit", color: AppColors.black, weight: FontWeight.w700),),
              ],
            ),
          ],
        ),
        //ride information
        Gap(16),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, color: AppColors.purple, size: 8),
                Gap(20.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 16, weight: FontWeight.w500, fontFamily: "Outfit")),
                    Gap(6),
                    Text("Pickup Location" ?? Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 18, weight: FontWeight.w600, fontFamily: "Outfit")),
                  ],
                ),
                const Spacer(),
                Text("11:14 AM" ?? Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w400, fontFamily: "Outfit")),
              ],
            ),
            Gap(16.h),
            DottedLine(height: 1, colors: [AppColors.greyEd], lineThickness: 0.5,),
            Gap(16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: AppColors.purple, size: 8),
                Gap(20.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Label.destination, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 16, weight: FontWeight.w500, fontFamily: "Outfit")),
                    Gap(6),
                    Text("Destination Location" ?? Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 18, weight: FontWeight.w600, fontFamily: "Outfit")),
                  ],
                ),
                const Spacer(),
                Text("", style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 12, weight: FontWeight.w400, fontFamily: "Outfit")),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
