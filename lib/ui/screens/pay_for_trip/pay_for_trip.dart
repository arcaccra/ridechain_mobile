import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/ui/screens/pay_for_trip/payment_success_screen.dart';
import 'package:ridex/ui/screens/pay_for_trip/widgets/wallet_information_card.dart';
import 'package:ridex/ui/shared_widgets/accepted_trip_detail_widget.dart';
import 'package:ridex/ui/shared_widgets/custom_app_bar.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../shared_widgets/default_button.dart';

class PayForTrip extends StatelessWidget {
  const PayForTrip({super.key});

  @override
  Widget build(BuildContext context) {
    final rideVm = Provider.of<RideProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Gap(20.h),
          CustomLoginAppBar(),
          Gap(10.h),
          Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Row(
            children: [
              WalletInformationCard(
              ),
              Gap(10.w),
              Expanded(child: DottedBorder(
                options: RoundedRectDottedBorderOptions(radius: Radius.circular(20), color: AppColors.purple, strokeCap: StrokeCap.round),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.lightPurple
                  ),
                  width: 1.sw,
                  height: 217.h,
                  child: Icon(Icons.add, color: AppColors.purple,),
                ),))
            ],
          ),),
          Gap(20.h),
          Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Label.completePayment, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 13, weight: FontWeight.w800, fontFamily: "Outfit")),
              Gap(20.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: AcceptedTripDetailWidget(ride: rideVm.selectedRide,),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                          color: AppColors.purple,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Label.rideStatus, style: AppThemes.getCustomTextStyle(color: AppColors.white, fontSize: 11, weight: FontWeight.w500, fontFamily: "Outfit")),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(Label.completed, style: AppThemes.getCustomTextStyle(color: AppColors.yellow, fontSize: 11, weight: FontWeight.w500, fontFamily: "Outfit")),
                              Gap(4.w),
                              Icon(Icons.check_circle, color: AppColors.yellow, size: 14)
                            ],
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
              Gap(40.h),
              DefaultButton(
                onBtnTap: (){
                  Get.to(() => const PaymentSuccessScreen());
                },
                btnText: Label.payNow,
                isIconPresent: false,
                btnColor: AppColors.purple,
                btnTextColor: AppColors.white,
              ),
            ],
          ),)),

        ],
      ),
    );
  }
}
