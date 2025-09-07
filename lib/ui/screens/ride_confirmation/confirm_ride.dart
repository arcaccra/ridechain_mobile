import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/ui/screens/ride_confirmation/widgets/ride_pickup_and_destination.dart';
import 'package:ridex/ui/shared_widgets/default_back_button.dart';

import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../core/core_constants/media.dart';
import '../../../app/theme.dart';
import '../../shared_widgets/default_button.dart';


class ConfirmRide extends StatelessWidget {
  final RideModel? ride;
  final VoidCallback? onCancelTap;
  final VoidCallback? onConfirmTap;
  const ConfirmRide({super.key, this.ride, this.onCancelTap, this.onConfirmTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 0.95.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16),
            const Row(
              children: [
                DefaultBackButton(
                  iconColor: AppColors.black,
                ),
              ],
            ),
            Gap(16.h),
            SizedBox(
              height: 0.25.sh,
              width: double.infinity,
              child: Stack(
                children: [
                   Positioned(
                     left: 16,
                     top: 16,
                     child: Text(
                      'Confirm\nyour ride',
                       style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 42, color: AppColors.black, weight: FontWeight.w700),
                     ),
                   ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        Media.cutToyota,
                        height: 186,
                      ),)
                ],
              ),
            ),
            Gap(24.h),
            Container(
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver Details',
                    style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 12, color: AppColors.greyAd, weight: FontWeight.w700),
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=3',
                        ),
                      ),
                      Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(ride?.driver?.user?.fullName ?? "", style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 22, weight: FontWeight.w800, color: AppColors.black)),
                                Text("ADA ${ride?.pricePerSeat ?? 0.00}", style: AppThemes.getCustomTextStyle(fontSize: 16, color: AppColors.black, weight: FontWeight.w800),),
                              ],
                            ),
                            Gap(12.h),
                            Row(
                              children: [
                                SvgPicture.asset(Media.steering, height: 12, width: 12,colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                                Gap(4),
                                Text(ride?.driver?.vehicleType ?? "", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w400),),
                                Spacer(),
                                SvgPicture.asset(Media.blackCar, height: 12, width: 12 ,colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                                Gap(4),
                                Text(ride?.driver?.vehiclePlateNumber ?? "", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w700),),
                              ],
                            ),
                            Gap(12.h),
                            Row(
                              children: [
                                Icon(Icons.star, size:12, color: AppColors.yellow,),
                                Gap(4),
                                Text("4.7/5 Rating", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w700),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(10.h),
            //pickup and destination
            RidePickupAndDestination(pickupLocation: ride?.pickUp?.name, destinationLocation: ride?.dropOff?.name),
            Gap(30.h),
            Align(
              alignment: Alignment.center,
              child: DefaultButton(
                onBtnTap: onConfirmTap!,
                btnText: Label.buttonConfirmLabel,
                isIconPresent: false,
                width: 0.7.sw,
                btnColor: AppColors.purple,
                btnTextColor: AppColors.white,
              ),
            ),
            Gap(10.h),
            Align(
              alignment: Alignment.center,
              child: DefaultButton(
                onBtnTap: onCancelTap!,
                btnText: Label.buttonCancelText,
                isIconPresent: false,
                width: 0.7.sw,
                btnColor: AppColors.lightPurple,
                btnTextColor: AppColors.purple,
              ),
            ),
          ],
        ),
      );
  }
}
