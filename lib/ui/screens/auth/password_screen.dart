import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/password_form.dart';
import 'package:ridex/ui/screens/auth/image_capture_screen.dart';

import '../../../core/colors.dart';
import '../../../core/label.dart';
import '../../../core/theme.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/default_button.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
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
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Gap(20.h),
                          Text(Label.passwordScreenTitleLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 38, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(4.h),
                          Text(Label.passwordScreenMessageLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 16, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(0.15.sh),
                          PasswordForm(formKey: _formKey, passwordController: _passwordCtrl, confirmPasswordController: _confirmPasswordCtrl,),
                          Gap(50.h),
                          DefaultButton(
                            onBtnTap: () async {
                              if (_formKey.currentState!.validate()) {
                                Get.to(()=> ImageCaptureScreen());
                              }
                            },
                            btnText: Label.buttonContinueLabel,
                            isIconPresent: false,
                            btnColor: AppColors.primaryColor,
                            btnTextColor: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(16.h),
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
