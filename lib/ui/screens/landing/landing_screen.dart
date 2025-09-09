import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ridex/core/core_constants/colors.dart';
import 'package:ridex/ui/screens/auth/register_screen.dart';

import '../../../core/core_constants/label.dart';
import '../../../core/core_constants/media.dart';
import '../../../app/theme.dart';
import '../../shared_widgets/default_button.dart';
import '../auth/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: double.infinity, width: double.infinity, child: Image.asset(Media.landingImage, fit: BoxFit.cover)),
          Positioned(
            top: 40.h,
            left: 0,
            right: 0,
            child: Text(Label.appNameLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 20, color: AppColors.primaryColor))
                .animate(delay: 200.ms)
                .slide(
                  begin: const Offset(0, -0.3), // Start from top of screen
                  end: const Offset(0, 0), // End at center
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutBack,
                )
                .fade(begin: 0, end: 1, duration: 500.ms, delay: 200.ms),
          ),
          Positioned(
            top: 0.5.sh,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Label.landingScreenTitleLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", fontSize: 72, color: AppColors.primaryColor,), textAlign: TextAlign.left, )
                    .animate(delay: 200.ms)
                    .slide(
                  begin: const Offset(0, -0.3), // Start from top of screen
                  end: const Offset(0, 0), // End at center
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutBack,
                ).fade(begin: 0, end: 1, duration: 500.ms, delay: 200.ms),

                Text(Label.landingScreenMessageLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", fontSize: 24, color: AppColors.primaryColor,), textAlign: TextAlign.left, )
                    .animate(delay: 200.ms)
                    .slide(
                  begin: const Offset(0, -0.3), // Start from top of screen
                  end: const Offset(0, 0), // End at center
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutBack,
                ).fade(begin: 0, end: 1, duration: 500.ms, delay: 200.ms),

                Gap(60.h),
                DefaultButton(
                  onBtnTap: (){
                    Get.to(() => const LoginScreen());
                  },
                  btnText: Label.buttonLoginLabel,
                  btnColor: AppColors.purple,
                  btnTextColor: AppColors.white,
                  width: 1.sw,
                ),
                Gap(10.h),
                DefaultButton(
                  onBtnTap: (){
                    Get.to(() => const RegisterScreen());
                  },
                  btnText: Label.buttonRegisterLabel,
                  btnColor: AppColors.lightPurple,
                  btnTextColor: AppColors.purple,
                  width: 1.sw,
                ),
                Gap(10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
