import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';


class UserProfileWidgets extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final String? text;
  const UserProfileWidgets({super.key, this.onTap, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.black,),
            Gap(10),
            Text(text ?? "Anon", style: AppThemes.getCustomTextStyle(fontSize: 14, weight: FontWeight.w500, color: AppColors.black, lineHeight: 0.70, spacing: 0),),
          ],
        ),
      ),
    );
  }
}
