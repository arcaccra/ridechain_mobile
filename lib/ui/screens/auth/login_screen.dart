import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/core/label.dart';
import 'package:ridex/core/theme.dart';

import '../../../core/colors.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/default_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(20.h),
                const CustomLoginAppBar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gap(20.h),
                        Text(
                          Label.loginScreenTitleLabel,
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: "Zain",
                            weight: FontWeight.w900,
                            color: AppColors.primaryColor,
                            fontSize: 38,
                            lineHeight: 1.33,
                          ),
                          textAlign: TextAlign.center,
                        ).animate(delay: 100.ms)
                            .slide(
                          begin: const Offset(0, -0.3),
                          end: const Offset(0, 0), // End at center
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        )
                            .fade(begin: 0, end: 1, duration: 600.ms),
                        Gap(4.h),
                        Text(
                          Label.loginScreenMessageLabel,
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: "Zain",
                            weight: FontWeight.w700,
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            lineHeight: 1.33,
                          ),
                          textAlign: TextAlign.center,
                        ).animate(delay: 100.ms)
                            .slide(
                          begin: const Offset(0, -0.3),
                          end: const Offset(0, 0), // End at center
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        )
                            .fade(begin: 0, end: 1, duration: 600.ms),
                        Gap(40.h),
                        DefaultButton(
                          onBtnTap: () async {
                          },
                          btnText: Label.buttonLoginLabel,
                          isIconPresent: false,
                          btnColor: AppColors.primaryColor,
                          btnTextColor: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(16.h),
                Gap(16.h)
              ],
            ),
            // Visibility(
            //   visible: authVm!.isLoading || authVm!.loading,
            //   child: const Loader(),
            // )
          ],
        ),
      ),
    );
  }
}
