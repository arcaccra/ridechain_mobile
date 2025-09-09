import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';

class WalletInformationCard extends StatelessWidget {
  final String? userImage;
  final String? walletAddress;
  final String? walletBalance;
  const WalletInformationCard({super.key, this.userImage, this.walletAddress, this.walletBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 217.h,
      width: 260.w,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(Label.adaWallet, style: AppThemes.getCustomTextStyle(color: AppColors.lightPurple, fontSize: 10, weight: FontWeight.w600, fontFamily: "Outfit")), CircleAvatar(radius: 18, backgroundImage: NetworkImage(userImage ?? 'https://i.pravatar.cc/150?img=3'))],
          ),
          Spacer(),
          Text("ADA ${walletBalance ?? "5826.99"}", style: AppThemes.getCustomTextStyle(color: AppColors.yellow, fontSize: 30, weight: FontWeight.w800, fontFamily: "Outfit"), overflow: TextOverflow.ellipsis,),
          Gap(4.h),
          Text(walletAddress ?? "hbaid748n349dcau49f30w48fhcern9w4hf84d84hfqwhf48h4wqo", style: AppThemes.getCustomTextStyle(color: AppColors.lightPurple, fontSize: 10, weight: FontWeight.w600, fontFamily: "Outfit")),
        ],
      ),
    );
  }
}
