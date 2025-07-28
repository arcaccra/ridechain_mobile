import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ridex/ui/screens/ride_confirmation/widgets/ride_pickup_and_destination.dart';
import 'package:ridex/ui/shared_widgets/default_back_button.dart';

import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../core/core_constants/media.dart';
import '../../../app/theme.dart';
import '../../shared_widgets/default_button.dart';


class ConfirmRide extends StatefulWidget {
  const ConfirmRide({super.key});

  @override
  State<ConfirmRide> createState() => _ConfirmRideState();
}

class _ConfirmRideState extends State<ConfirmRide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  DefaultBackButton(),
                ],
              ),
              Gap(16.h),
              SizedBox(
                height: 0.25.sh,
                width: double.infinity,
                child: Stack(
                  children: [
                     Align(
                       alignment: Alignment(16, 16),
                       child: Text(
                        'Confirm\nyour ride',
                         style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 32, color: AppColors.black, weight: FontWeight.w700),
                       ),
                     ),
                    Positioned(
                        bottom: 0,
                        left: 5,
                        child: Image.network(
                          Media.cutToyota,
                          height: 186,
                        ),)
                  ],
                ),
              ),
              Gap(24.h),
              Container(
                padding: const EdgeInsets.all(16),
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
                      style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 11, color: AppColors.greyAd, weight: FontWeight.w700),
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
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, size:8, color: AppColors.yellow,),
                                  Gap(4),
                                  Text("4.7/5 Rating", style: AppThemes.getCustomTextStyle(fontSize: 8.3, color: AppColors.purple, weight: FontWeight.w700),),
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
                  ],
                ),
              ),
              Gap(16.h),
              //pickup and destination
              RidePickupAndDestination(pickupLocation: "Nairobi", destinationLocation: "Nakuru"),
              Gap(30.h),
              DefaultButton(
                onBtnTap: (){},
                btnText: Label.buttonConfirmLabel,
                isIconPresent: false,
                btnColor: AppColors.primaryColor,
                btnTextColor: AppColors.white,
              ),
              Gap(10.h),
              DefaultButton(
                onBtnTap: (){},
                btnText: Label.buttonConfirmLabel,
                isIconPresent: false,
                btnColor: AppColors.lightPurple,
                btnTextColor: AppColors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
