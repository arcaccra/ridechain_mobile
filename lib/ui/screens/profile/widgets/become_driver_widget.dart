import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridex/core/core_constants/label.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/media.dart';

class BecomeDriverWidget extends StatelessWidget {
  final VoidCallback? onTap;
  const BecomeDriverWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //user info
            Text(Label.earnAsDriver, style: AppThemes.getCustomTextStyle(fontSize: 16, weight: FontWeight.w600, color: AppColors.white, lineHeight: 0.70, spacing: 0),),
            Image.asset(Media.onboardingToyotaImg, height: 60, width: 60,)
          ],
        ),
      ),
    );
  }
}
