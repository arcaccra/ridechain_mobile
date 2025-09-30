import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/ui/screens/profile/widgets/become_driver_widget.dart';
import 'package:ridex/ui/screens/profile/widgets/profile_top_widget.dart';
import 'package:ridex/ui/screens/profile/widgets/user_profile_widgets.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/default_button.dart';
import '../auth/login_screen.dart';
import '../settings/settings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthVm>(context);
    final rideVm = Provider.of<RideProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(20.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(20.h),
                      ProfileTopWidget(user: authVm.currentAuth?.user,)
                          .animate(delay: 100.ms)
                          .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                          .fade(begin: 0, end: 1, duration: 600.ms),
                      Gap(12.h),
                      BecomeDriverWidget(
                        onTap: (){},
                      )
                          .animate(delay: 100.ms)
                          .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                          .fade(begin: 0, end: 1, duration: 600.ms),
                      Gap(12.h),
                      UserProfileWidgets(
                        onTap: (){
                          Get.to(() => const Settings(), transition: Transition.rightToLeft);
                        },
                        text: Label.settings,
                        icon: Icons.settings,
                      )
                          .animate(delay: 100.ms)
                          .slide(
                        begin: const Offset(0, -0.3),
                        end: const Offset(0, 0), // End at center
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      )
                          .fade(begin: 0, end: 1, duration: 600.ms),
                    ],
                  ),
                ),
              ),
            ),
            DefaultButton(onBtnTap: () async {
              bool success = await authVm.logout();
              if(success) {
                rideVm.resetRideState();
                Get.offAll(() => const LoginScreen(), transition: Transition.leftToRight);
              }
            }, btnText: Label.logout, isIconPresent: false, borderPresent: false, btnColor: AppColors.backgroundColor, btnTextColor: AppColors.purple,),
            Gap(80.h),
          ],
        ),
      ),
    );
  }
}
