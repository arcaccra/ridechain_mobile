import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ridex/ui/shared_widgets/default_back_button.dart';
import 'package:ridex/ui/shared_widgets/default_button.dart';

import '../../core/core_constants/colors.dart';
import '../../core/core_constants/label.dart';
import '../../core/core_constants/media.dart';
import '../../app/theme.dart';


class DriverEnRouteCard extends StatelessWidget {
  const DriverEnRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //main text
        Text(Label.driverOnWay, style: AppThemes.getCustomTextStyle(fontSize: 20.2, color: AppColors.primaryColor, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
        Gap(10.h),
        //sub text
        Text("${Label.driverTimeAway} 5mins", style: AppThemes.getCustomTextStyle(fontSize: 11, color: AppColors.greyAd, weight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),
        Gap(30.h),
        DottedLine(
          axis: Axis.horizontal,
          lineThickness: 1,
          dashGap: 4,
          height: 1,
          dashWidth: 6,
          colors: [AppColors.textFieldBorderColor],
        ),
        Gap(30.h),
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
                  Gap(6),
                  Row(
                    children: [
                      SvgPicture.asset(Media.steering, height: 8.3, width: 8.3),
                      Gap(4),
                      Text("Hyundai Elantra (Silver)", style: AppThemes.getCustomTextStyle(fontSize: 8.3, color: AppColors.black, weight: FontWeight.w400),),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(Media.blackCar, height: 8.3, width: 8.3),
                      Gap(4),
                      Text("MNO-7890", style: AppThemes.getCustomTextStyle(fontSize: 8.3, color: AppColors.black, weight: FontWeight.w700),),
                      Gap(16),
                      Icon(Icons.star, size:8, color: AppColors.black,),
                      Gap(4),
                      Text("4.7/5 Rating", style: AppThemes.getCustomTextStyle(fontSize: 8.3, color: AppColors.black, weight: FontWeight.w700),),
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DefaultBackButton(
              onBackTap: () {},
              iconColor: AppColors.purple,
              btnColor: AppColors.lightPurple,
              icon: CupertinoIcons.chat_bubble_text,
            ),
            DefaultBackButton(
              onBackTap: () {},
              iconColor: AppColors.purple,
              btnColor: AppColors.lightPurple,
              icon: CupertinoIcons.phone,
            ),
          ],
        ),
        Gap(12),
        DefaultButton(
          onBtnTap: (){},
          btnText: Label.buttonCancelText,
          btnColor: AppColors.lightPurple,
          btnTextColor: AppColors.purple,
          btnFontWeight: FontWeight.w700,
          btnTextSize: 10,
        )
      ],
    );
  }
}
