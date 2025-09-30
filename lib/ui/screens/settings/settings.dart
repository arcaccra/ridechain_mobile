import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ridex/ui/shared_widgets/default_button.dart';

import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../profile/widgets/user_profile_widgets.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthVm>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(20.h),
            const CustomLoginAppBar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(20.h),
                      UserProfileWidgets(
                        onTap: (){},
                        text: Label.about,
                        icon: Icons.app_shortcut_rounded,
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
          ],
        ),
      ),
    );
  }
}
