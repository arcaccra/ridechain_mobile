import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';
import '../../../../core/core_constants/media.dart';
import '../../../shared_widgets/accepted_trip_detail_widget.dart';


class RideArrivalBottomWidget extends StatelessWidget {
  const RideArrivalBottomWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Label.estimatedTimeOfArrival, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 11, weight: FontWeight.w500, fontFamily: "Outfit")),
              Text(Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 12, weight: FontWeight.w500, fontFamily: "Outfit")),
            ],
          ),
          Gap(4),
          DottedLine(colors: [AppColors.textFieldBorderColor],),
          //user data and car ui
          AcceptedTripDetailWidget()
        ],
      ),
    );
  }
}
