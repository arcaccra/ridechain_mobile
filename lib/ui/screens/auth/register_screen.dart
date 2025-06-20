import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ridex/core/label.dart';
import 'package:ridex/core/media.dart';
import 'package:ridex/core/theme.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/no_account.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/sign_in_form.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/sign_up_form.dart';
import 'package:ridex/ui/screens/auth/otp_screen.dart';

import '../../../core/colors.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/default_button.dart';
import 'auth_widgets/or_continue.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryNotifier = ValueNotifier<Country?>(null);

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
                          Text(Label.registerScreenTitleLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 38, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(4.h),
                          Text(Label.registerScreenMessageLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 16, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(0.12.sh),
                          SignUpForm(emailController: _emailCtrl, nameController: _nameCtrl, countryController: _countryController, phoneController: _phoneController, formKey: _globalKey, countryNotifier: _countryNotifier),
                          Gap(50.h),
                          DefaultButton(
                            onBtnTap: () async {
                              if (_globalKey.currentState!.validate()) {
                                Get.to(()=> OtpScreen());
                              }
                            },
                            btnText: Label.buttonContinueLabel,
                            isIconPresent: false,
                            btnColor: AppColors.primaryColor,
                            btnTextColor: AppColors.white,
                          ),
                          Gap(30.h),
                          NoAccount(title: Label.registerYesAccountLabel, actionTitle: Label.registerSignInLabel, onPressed: () {
                            Get.back();
                          }),
                          Gap(30.h),
                          OrContinue(),
                          Gap(30.h),
                          DefaultButton(
                            onBtnTap: () async {
                              if (_globalKey.currentState!.validate()) {
                                Get.to(()=> OtpScreen());
                              }
                            },
                            btnText: Label.buttonGoogleLabel,
                            isIconPresent: true,
                            iconData: Media.google,
                            btnColor: AppColors.primaryColor.withValues(alpha: 0.1),
                            btnTextColor: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
