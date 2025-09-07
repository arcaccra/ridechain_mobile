import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridex/ui/screens/ride_arrival_estimation/widgets/ride_arrival_widget.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../core/core_constants/media.dart';
import '../../../data/locator.dart';
import '../../../data/models/ride_model.dart';
import '../../../services/dialog_service.dart';
import '../../../services/location_service.dart';
import '../../shared_widgets/default_button.dart';


class RideArrivalScreen extends StatefulWidget {
  final RideModel? ride;
  final VoidCallback? atDropOff;
  const RideArrivalScreen({super.key, this.ride, this.atDropOff});

  @override
  State<RideArrivalScreen> createState() => _RideArrivalScreenState();
}

class _RideArrivalScreenState extends State<RideArrivalScreen> {

  final location = locator<LocationService>();
  final dialog = locator<DialogService>();
  GoogleMapController? mapController;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Label.tripStarted, style: AppThemes.getCustomTextStyle(fontSize: 20.2, color: AppColors.primaryColor, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
        Gap(10.h),
        //sub text
        Text(Label.tripStartedMessage, style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.greyAd, weight: FontWeight.w500), maxLines: 4, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
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
              radius: 18,
              backgroundImage: NetworkImage(
                widget.ride?.driver?.user?.avatar ?? "",
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
                      Text(widget.ride?.driver?.user?.fullName ?? "", style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 22, weight: FontWeight.w800, color: AppColors.black)),
                      Text("ADA ${widget.ride?.pricePerSeat ?? 0.00}", style: AppThemes.getCustomTextStyle(fontSize: 16, color: AppColors.black, weight: FontWeight.w800),),
                    ],
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      SvgPicture.asset(Media.steering, height: 12, width: 12,colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                      Gap(4),
                      Text(widget.ride?.driver?.vehicleType ?? "", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w400),),
                      Spacer(),
                      SvgPicture.asset(Media.blackCar, height: 12, width: 12 ,colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                      Gap(4),
                      Text(widget.ride?.driver?.vehiclePlateNumber ?? "", style: AppThemes.getCustomTextStyle(fontSize: 12, color: AppColors.black, weight: FontWeight.w700),),
                    ],
                  ),
                  Gap(12.h),
                  RideArrivalLocationWidget(title: Label.pickup, name: widget.ride?.pickUp?.name ?? "N/A", timeDate: "10:24pm", iconData: Icons.circle,),
                  Gap(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 0.60.sw,
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
                    ],
                  ),
                  Gap(20.h),
                  RideArrivalLocationWidget(title: Label.destination, name: widget.ride?.dropOff?.name ?? "N/A", timeDate: "11:50pm", iconData: Icons.circle,),
                  Gap(22),
                  DefaultButton(
                    onBtnTap: widget.atDropOff!,
                    btnText: Label.dropOff,
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
      ],
    );
  }
}
