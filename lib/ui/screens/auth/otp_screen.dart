import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/otp_fields.dart';
import 'package:ridex/ui/screens/auth/password_screen.dart';

import '../../../core/colors.dart';
import '../../../core/label.dart';
import '../../../core/theme.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/default_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  Timer? _timer;
  int _countdown = 30;
  bool _isActive = true;
  bool _canRestart = false;
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 30;
      _isActive = true;
      _canRestart = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isActive = false;
          _canRestart = true;
        });
      }
    });
  }

  void _restartCountdown() {
    _timer?.cancel();
    _startCountdown();
    // Here you can add your resend OTP logic
    _resendOTP();
  }

  void _resendOTP() {
    // Add your OTP resend logic here
    print('Resending OTP...');
    // Example: Call your API to resend OTP
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }


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
                          Text(Label.verifyScreenTitleLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 38, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(4.h),
                          Text(Label.verifyScreenMessageLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 16, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0), // End at center
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(0.15.sh),
                          OtpFields(otpCtrl: _otpController,),
                          Gap(0.15.sh),
                          DefaultButton(
                            onBtnTap: () async {
                              Get.to(()=> PasswordScreen());
                            },
                            btnText: Label.buttonVerifyLabel,
                            isIconPresent: false,
                            btnColor: AppColors.primaryColor,
                            btnTextColor: AppColors.white,
                          ),
                          Gap(30.h),
                          GestureDetector(
                            onTap: () {},
                            child: Text(Label.verifyChangePhoneLabel, style: AppThemes.getCustomTextStyle(
                              fontFamily: "BeauSans",
                              fontSize: 13,
                              weight: FontWeight.normal
                            ),),
                          ),
                          Gap(0.15.sh),
                          Text(Label.verifyScreenNoOtpLabel, style: AppThemes.getCustomTextStyle(
                              fontFamily: "BeauSans",
                              fontSize: 12,
                              weight: FontWeight.w700,
                          ),),
                          Gap(10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _canRestart ? _restartCountdown : null,
                                child: Text(_isActive ? Label.verifyScreenResentOtpLabel : Label.verifyScreenReadyToResendLabel, style: AppThemes.getCustomTextStyle(
                                  fontFamily: "BeauSans",
                                  fontSize: 12,
                                  weight: FontWeight.w300,
                                ),),
                              ),
                              if(_isActive)Text(_formatTime(_countdown), style: AppThemes.getCustomTextStyle(
                                fontFamily: "BeauSans",
                                fontSize: 12,
                                weight: FontWeight.w600,
                              ),),
                            ],
                          )
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
