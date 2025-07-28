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
                children: [
                  Text("John Doe", style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 14.42, weight: FontWeight.w700, color: AppColors.black)),
                  Row(
                    children: [
                      SvgPicture.asset(Media.steering, height: 8.3, width: 8.3),
                      Gap(4),
                      Text("Hyundai Elantra (Silver)", style: AppThemes.getCustomTextStyle(fontSize: 8.3, color: AppColors.black, weight: FontWeight.w400),),
                      Gap(16),
                      SvgPicture.asset(Media.blackCar, height: 8.3, width: 8.3),
                      Gap(4),
                      Text("MNO-7890", style: AppThemes.getCustomTextStyle(fontSize: 8.3, color: AppColors.black, weight: FontWeight.w700),),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text("${Label.ada} 28.50", style: AppThemes.getCustomTextStyle(fontSize: 13.33, color: AppColors.black, weight: FontWeight.w700),),
              ],
            ),
          ],
        ),
        //ride information
        Gap(10),
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
                    Text(Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 12, weight: FontWeight.w700, fontFamily: "Outfit")),
                    Text("Pickup Locatiom" ?? Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 13, weight: FontWeight.w700, fontFamily: "Outfit")),
                  ],
                ),
                const Spacer(),
                Text("11:14 AM" ?? Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 8.3, weight: FontWeight.w400, fontFamily: "Outfit")),
              ],
            ),
            DottedLine(height: 1, colors: [AppColors.greyEd],),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, color: AppColors.purple, size: 8),
                Gap(20.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Label.destination, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 12, weight: FontWeight.w700, fontFamily: "Outfit")),
                    Text("Destination Location" ?? Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 13, weight: FontWeight.w700, fontFamily: "Outfit")),
                  ],
                ),
                const Spacer(),
                Text("", style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 13, weight: FontWeight.w400, fontFamily: "Outfit")),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
