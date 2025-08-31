import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/ui/shared_widgets/pickup_destination_widget.dart';

import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../shared_widgets/available_car_card.dart';
import '../../shared_widgets/default_button.dart';

class ShowAvailableCarsWidget extends StatelessWidget {
  const ShowAvailableCarsWidget({super.key, this.destination, required this.onBtnTap});
  final String? destination;
  final VoidCallback onBtnTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16,),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.11),
              spreadRadius: 0,
              blurRadius: 13.4,
              offset: Offset(0, 3.27),)
          ]
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: PickupDestinationWidget(title: Label.pickup, data: "My Location",)),
                  Gap(12.w),
                  Expanded(child: PickupDestinationWidget(title: Label.destination, data: destination ?? "",)),
                ],
              ),
            ),
          ),
          Gap(16.h),
          SizedBox(
            height: 160.h,
            width: 1.sw,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return AvailableCarCard(
                  amount: 14.5,
                  minutes: 7,
                  rating: 4.5,
                );
              }
          )
          ),
          Gap(24.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: DefaultButton(
              onBtnTap: onBtnTap,
              btnText: Label.bookNow,
              isIconPresent: false,
              btnColor: AppColors.primaryColor,
              btnTextColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
