import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ridex/core/utility.dart';
import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/services/location_service.dart';
import 'package:ridex/ui/shared_widgets/default_back_button.dart';
import 'package:ridex/ui/shared_widgets/default_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core_constants/colors.dart';
import '../../core/core_constants/label.dart';
import '../../core/core_constants/media.dart';
import '../../app/theme.dart';
import '../../data/locator.dart';


class DriverEnRouteCard extends StatelessWidget {
  final RideModel? ride;
  final VoidCallback? onCancelTap;
  const DriverEnRouteCard({super.key, this.ride, this.onCancelTap});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //main text
        Text(Label.meetDriver, style: AppThemes.getCustomTextStyle(fontSize: 20.2, color: AppColors.primaryColor, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
        Gap(10.h),
        //sub text
        Text(Label.driverTimeAway, style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.greyAd, weight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),
        Gap(10.h),
        SizedBox(
          width: 0.6.sw,
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
        Gap(30.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(
                ride?.driver?.user?.avatar ?? "",
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
                      Text(ride?.driver?.user?.fullName ?? "", style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 18, weight: FontWeight.w700, color: AppColors.black)),
                      Text("ADA ${ride?.pricePerSeat ?? 0.00}", style: AppThemes.getCustomTextStyle(fontSize: 16.33, fontFamily: "Outfit", color: AppColors.black, weight: FontWeight.w800),),
                    ],
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      SvgPicture.asset(Media.steering, height: 12, width: 12,colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                      Gap(4),
                      Text(ride?.driver?.vehicleType ?? "", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w400),),
                    ],
                  ),
                  Gap(12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Media.blackCar, height: 12, width: 12 ,colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                      Gap(4),
                      Text(ride?.driver?.vehiclePlateNumber ?? "", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w700),),
                      Gap(20),
                      SvgPicture.asset(Media.carSeat, height: 13, width: 11 ,colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                      Gap(4),
                      Text("${ride?.seatsAvailable ?? 0} Seats", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w700),),
                      Spacer(),
                      DefaultBackButton(
                        onBackTap: () {
                          locator<LocationService>().showDirectionToDriver(ride!.pickUp!.latitude!, ride!.pickUp!.longitude!);
                        },
                        iconColor: AppColors.purple,
                        btnColor: AppColors.lightPurple,
                        size: 39,
                        iconSize: 15,
                        icon: CupertinoIcons.location,
                      ),
                      Gap(12),
                      DefaultBackButton(
                        onBackTap: () {
                          Utils.makePhoneCall(ride!.driver!.user!.phoneNumber!);
                        },
                        size: 39,
                        iconSize: 15,
                        iconColor: AppColors.purple,
                        btnColor: AppColors.lightPurple,
                        icon: CupertinoIcons.phone,
                      ),
                       ],
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      Icon(Icons.star, size:12, color: AppColors.orange,),
                      Gap(4),
                      Text("4.7/5 Rating", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w700),),
                    ],
                  ),
                  Gap(22),
                  DefaultButton(
                    onBtnTap: onCancelTap!,
                    btnText: Label.buttonCancelText,
                    btnColor: AppColors.lightPurple,
                    btnTextColor: AppColors.purple,
                    height: 40,
                    btnFontWeight: FontWeight.w700,
                    btnTextSize: 16,
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
