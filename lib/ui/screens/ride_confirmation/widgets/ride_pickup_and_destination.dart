import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';
import '../../../../core/core_constants/media.dart';


class RidePickupAndDestination extends StatelessWidget {
  const RidePickupAndDestination({super.key, this.pickupLocation, this.destinationLocation});

  final String? pickupLocation;
  final String? destinationLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 80, width: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.backgroundColor), child: Center(child: SvgPicture.asset(Media.car))),
              Gap(12),
              Expanded(child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, color: AppColors.purple, size: 14),
                      Gap(10.w),
                      Flexible(child: Text(pickupLocation ?? Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 16, weight: FontWeight.w400, fontFamily: "Outfit",), maxLines: 4,)),

                    ],
                  ),
                  Gap(20),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.purple, size: 14),
                      Gap(10.w),
                      Flexible(child: Text(destinationLocation ?? Label.destination, style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 16, weight: FontWeight.w400, fontFamily: "Outfit"), maxLines: 4,)),
                    ],
                  ),
                ],
              )),

            ],
          ),
        ],
      ),
    );
  }
}
