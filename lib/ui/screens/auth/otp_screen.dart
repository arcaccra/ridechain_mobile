import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/ui/screens/auth/password_screen.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';
import 'auth_widgets/otp_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _totalSeconds = 60;

  final TextEditingController _otpCtrl = TextEditingController();
  Timer? _timer;
  int _countdown = _totalSeconds;
  bool _canResend = false;

  late AuthVm _authVm;

  @override
  void initState() {
    super.initState();
    _authVm = context.read<AuthVm>();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _countdown = _totalSeconds;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  void _resend() {
    _startCountdown();
    log('Resending OTP...');
    _authVm.resendOTP(_authVm.body['phone_number']);
  }

  Future<void> _verify() async {
    final code = _otpCtrl.text.trim();
    if (code.length < 6) {
      Get.snackbar('Invalid code', 'Please enter the 6-digit code.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.purple,
          colorText: Colors.white);
      return;
    }
    await _authVm.verifyOTP(code);
    if (!mounted) return;
  }

  /// Masks a phone number: "+233244440123" → "+233 24 ••• 0123"
  String _maskPhone(String? raw) {
    if (raw == null || raw.isEmpty) return '••• ••• •••';
    // Keep first 7 chars visible, last 4 visible, mask middle
    if (raw.length <= 8) return raw;
    final prefix = raw.substring(0, raw.length - 4).replaceRange(
        raw.length > 10 ? 7 : 4, raw.length - 4, ' ••• ');
    final suffix = raw.substring(raw.length - 4);
    return '$prefix$suffix';
  }

  String _formatCountdown(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(1, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    _authVm = context.watch<AuthVm>();
    final phone = _maskPhone(_authVm.body['phone_number'] as String?);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back + progress
                Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 24.w),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    color: AppColors.primaryColor,
                    onPressed: () => Get.back(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 2 / 4,
                      backgroundColor: Color(0xFFE5E7EB),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.purple),
                      minHeight: 4,
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(40.h),

                        // Phone icon circle
                        Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEDE8FA),
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            color: AppColors.purple,
                            size: 36,
                          ),
                        )
                            .animate()
                            .fade(begin: 0, end: 1, duration: 400.ms)
                            .scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1, 1),
                                duration: 400.ms,
                                curve: Curves.easeOut),

                        Gap(28.h),

                        // Title
                        Text(
                          'Enter the code',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 28,
                            weight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(delay: 80.ms)
                            .fade(begin: 0, end: 1, duration: 400.ms),

                        Gap(8.h),

                        // Subtitle with masked phone
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              weight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                            children: [
                              const TextSpan(text: 'Sent to '),
                              TextSpan(
                                text: phone,
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(delay: 120.ms)
                            .fade(begin: 0, end: 1, duration: 400.ms),

                        Gap(36.h),

                        // OTP boxes
                        OtpFields(otpCtrl: _otpCtrl)
                            .animate(delay: 160.ms)
                            .fade(begin: 0, end: 1, duration: 400.ms),

                        Gap(20.h),

                        // Resend timer / link
                        _canResend
                            ? GestureDetector(
                                onTap: _resend,
                                child: Text(
                                  'Resend code',
                                  style: AppThemes.getCustomTextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    weight: FontWeight.w600,
                                    color: AppColors.purple,
                                  ),
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: AppThemes.getCustomTextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    weight: FontWeight.w400,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  children: [
                                    const TextSpan(text: 'Resend in '),
                                    TextSpan(
                                      text: _formatCountdown(_countdown),
                                      style: AppThemes.getCustomTextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        weight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        Gap(24.h),
                      ],
                    ),
                  ),
                ),

                // Verify button
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: DefaultButton(
                    onBtnTap: _verify,
                    btnText: 'Verify',
                    btnColor: AppColors.purple,
                    btnTextColor: AppColors.white,
                  ),
                ),
              ],
            ),

            if (_authVm.isLoading) const Loader(),
          ],
        ),
      ),
    );
  }
}
