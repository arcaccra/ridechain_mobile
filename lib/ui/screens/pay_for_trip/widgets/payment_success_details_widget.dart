import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/data/models/ride_model.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';


class PaymentSuccessDetailsWidget extends StatelessWidget {
  final RideModel? ride;
  const PaymentSuccessDetailsWidget({super.key, this.ride});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Label.driver, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w500, fontFamily: "Outfit")),
            Text(ride?.driver?.user?.fullName ?? "", style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 14, weight: FontWeight.w600, fontFamily: "Outfit")),
          ],
        ),
        Gap(28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Label.rideFare, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w500, fontFamily: "Outfit")),
            Text("ADA ${ride?.pricePerSeat ?? ""}", style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 14, weight: FontWeight.w600, fontFamily: "Outfit")),
          ],
        ),
        Gap(28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Label.pickup, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w500, fontFamily: "Outfit")),
            Text(ride?.pickUp?.name ?? "", style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 14, weight: FontWeight.w600, fontFamily: "Outfit")),
          ],
        ),
        Gap(28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Label.destination, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w500, fontFamily: "Outfit")),
            Text(ride?.dropOff?.name ?? "", style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 14, weight: FontWeight.w600, fontFamily: "Outfit")),
          ],
        ),
        Gap(28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Label.paymentMethod, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w500, fontFamily: "Outfit")),
            Text("ADA", style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 14, weight: FontWeight.w600, fontFamily: "Outfit")),
          ],
        ),
        Gap(28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Label.transactionId, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w500, fontFamily: "Outfit")),
            Text("09438784774832h3", style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 14, weight: FontWeight.w600, fontFamily: "Outfit")),
          ],
        ),
        Gap(28),
        SizedBox(
          width: double.infinity,
          child: DottedLine(
            axis: Axis.horizontal,
            lineThickness: 1,
            dashGap: 4,
            height: 1,
            dashWidth: 6,
            shadowBlurRadius: 0,
            shadowColor: Colors.transparent,
            colors: [AppColors.textFieldBorderColor],
          ),
        ),
        Gap(28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Label.total, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 14, weight: FontWeight.w500, fontFamily: "Outfit")),
            Text("ADA ${ride?.pricePerSeat ?? ""}", style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 14, weight: FontWeight.w600, fontFamily: "Outfit")),
          ],
        ),
      ],
    );
  }
}
