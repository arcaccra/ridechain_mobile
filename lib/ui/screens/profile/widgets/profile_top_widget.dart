import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/app/theme.dart';
import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/data/models/user_model.dart';

import '../../../../core/core_constants/colors.dart';

class ProfileTopWidget extends StatelessWidget {
  final UserModel? user;
  final String? adaBalance;
  final String? walletAddress;
  const ProfileTopWidget({super.key, this.user, this.adaBalance, this.walletAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //user profile and image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //user profile
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.fullName ?? "Anon", style: AppThemes.getCustomTextStyle(fontSize: 20, weight: FontWeight.w800, color: AppColors.black, lineHeight: 0.67, spacing: 0),),
                  Gap(10),
                  Text(user?.phoneNumber ?? "+233548752965", style: AppThemes.getCustomTextStyle(fontSize: 14, weight: FontWeight.w400, color: AppColors.greyAd, lineHeight: 0.70, spacing: 0),),
                  Gap(10),
                  Text(user?.email ?? "anon@anon.com", style: AppThemes.getCustomTextStyle(fontSize: 14, weight: FontWeight.w400, color: AppColors.greyAd, lineHeight: 0.70, spacing: 0),),
                ],
              ),
              //user image
              SizedBox(
                height: 90,
                width: 90,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.greyAd,
                      foregroundColor: AppColors.primaryColor,
                      foregroundImage: NetworkImage(user?.avatar ?? ""),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 14,
                      child: Container(
                        height: 23,
                        width: 23,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green,
                          border: Border.all(color: AppColors.white, width: 2.4)
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Gap(50.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wallet Address: ${walletAddress ?? "N/A"}", style: AppThemes.sora(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.greyAd), overflow: TextOverflow.ellipsis,),
              Gap(10.h),
              Text("ADA ${adaBalance ?? 0.00}", style: AppThemes.getCustomTextStyle(fontSize: 42, weight: FontWeight.w800, color: AppColors.purple),),
            ],
          )
        ],
      ),
    );
  }
}
