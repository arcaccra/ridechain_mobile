import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:ridex/core/core_constants/label.dart';
import 'package:ridex/core/core_constants/media.dart';
import 'package:ridex/app/theme.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/no_account.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/sign_in_form.dart';
import 'package:ridex/ui/screens/auth/register_screen.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';

import '../../../core/core_constants/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';
import 'auth_widgets/or_continue.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthVm>(context);
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
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Gap(20.h),
                          Text(Label.loginScreenTitleLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 38, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                                begin: const Offset(0, -0.3),
                                end: const Offset(0, 0), // End at center
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(4.h),
                          Text(Label.loginScreenMessageLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 16, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                                begin: const Offset(0, -0.3),
                                end: const Offset(0, 0), // End at center
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(0.15.sh),
                          SignInForm(formKey: _globalKey, emailController: _emailCtrl, passwordController: _passwordCtrl),
                          Gap(50.h),
                          DefaultButton(
                            onBtnTap: () async {
                              if (_globalKey.currentState!.validate()) {
                                final email = _emailCtrl.text.trim();
                                final password = _passwordCtrl.text.trim();
                                authVm.addToRegisterMap("email", email);
                                authVm.addToRegisterMap("password", password);
                                await authVm.login();
                              }
                            },
                            btnText: Label.buttonLoginLabel,
                            isIconPresent: false,
                            btnColor: AppColors.purple,
                            btnTextColor: AppColors.white,
                          ),
                          Gap(30.h),
                          NoAccount(title: Label.loginNoAccountLabel, actionTitle: Label.loginSignUpLabel, onPressed: () {
                            Get.to(()=> RegisterScreen());
                          }),
                          Gap(30.h),
                          // OrContinue(),
                          // Gap(30.h),
                          // DefaultButton(
                          //   onBtnTap: () async {
                          //     if (_globalKey.currentState!.validate()) {
                          //       Get.to(()=> AppNavigationScreen());
                          //     }
                          //   },
                          //   btnText: Label.buttonGoogleLabel,
                          //   isIconPresent: true,
                          //   iconData: Media.google,
                          //   btnColor: AppColors.primaryColor.withValues(alpha: 0.1),
                          //   btnTextColor: AppColors.primaryColor,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(16.h),
              ],
            ),
            Visibility(
              visible: authVm.isLoading,
              child: const Loader(),
            )
          ],
        ),
      ),
    );
  }
}
