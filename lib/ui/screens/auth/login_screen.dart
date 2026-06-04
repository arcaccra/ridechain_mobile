import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/core/utility.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthVm authVm) async {
    if (!_formKey.currentState!.validate()) return;
    authVm.addToRegisterMap('email', _emailCtrl.text.trim());
    authVm.addToRegisterMap('password', _passwordCtrl.text.trim());
    await authVm.login();
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthVm>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 8.w),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    color: AppColors.primaryColor,
                    onPressed: () => Get.back(),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(8.h),

                          // Title
                          Text(
                            'Welcome back',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 32,
                              weight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          )
                              .animate()
                              .fade(begin: 0, end: 1, duration: 400.ms)
                              .slideY(begin: -0.1, end: 0, duration: 400.ms),

                          Gap(6.h),

                          // Subtitle
                          Text(
                            'Sign in to continue your ride.',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              weight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          )
                              .animate(delay: 60.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(32.h),

                          // Email or phone label
                          _FieldLabel('Email or phone'),
                          Gap(6.h),
                          CustomTextField(
                            controller: _emailCtrl,
                            hintText: 'kwame@arc.app',
                            keyboardType: TextInputType.emailAddress,
                            fillColor: const Color(0xFFEEEAF8),
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!Utils.emailRegex.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ).animate(delay: 100.ms).fade(
                              begin: 0, end: 1, duration: 400.ms),

                          Gap(16.h),

                          // Password label
                          _FieldLabel('Password'),
                          Gap(6.h),
                          CustomTextField(
                            controller: _passwordCtrl,
                            hintText: '••••••••',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscurePassword,
                            fillColor: const Color(0xFFEEEAF8),
                            prefixIcon: const Icon(
                              Icons.shield_outlined,
                              color: Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF9CA3AF),
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ).animate(delay: 150.ms).fade(
                              begin: 0, end: 1, duration: 400.ms),

                          Gap(12.h),

                          // Forgot password
                          GestureDetector(
                            onTap: () {
                              // TODO: navigate to forgot password screen
                            },
                            child: Text(
                              'Forgot password?',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                weight: FontWeight.w600,
                                color: AppColors.purple,
                              ),
                            ),
                          ).animate(delay: 180.ms).fade(
                              begin: 0, end: 1, duration: 400.ms),

                          Gap(28.h),

                          // Sign in button
                          DefaultButton(
                            onBtnTap: () => _submit(authVm),
                            btnText: 'Sign in',
                            btnColor: AppColors.purple,
                            btnTextColor: AppColors.white,
                          ).animate(delay: 220.ms).fade(
                              begin: 0, end: 1, duration: 400.ms),

                          Gap(28.h),

                          // Or continue with divider
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  'or continue with',
                                  style: AppThemes.getCustomTextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    weight: FontWeight.w400,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                            ],
                          ).animate(delay: 260.ms).fade(
                              begin: 0, end: 1, duration: 400.ms),

                          Gap(20.h),

                          // Social buttons row
                          Row(
                            children: [
                              Expanded(child: _SocialPill(label: 'Apple')),
                              SizedBox(width: 10.w),
                              Expanded(child: _SocialPill(label: 'Google')),
                              SizedBox(width: 10.w),
                              Expanded(child: _SocialPill(label: 'Wallet')),
                            ],
                          ).animate(delay: 300.ms).fade(
                              begin: 0, end: 1, duration: 400.ms),

                          Gap(32.h),

                          // Don't have an account
                          Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      weight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () => Get.to(() => const Register()),
                                      child: Text(
                                        'Sign up',
                                        style: AppThemes.getCustomTextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          weight: FontWeight.w700,
                                          color: AppColors.purple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(delay: 340.ms).fade(
                              begin: 0, end: 1, duration: 400.ms),

                          Gap(24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Full-screen loading overlay
            if (authVm.isLoading) const Loader(),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppThemes.getCustomTextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        weight: FontWeight.w500,
        color: const Color(0xFF374151),
      ),
    );
  }
}

class _SocialPill extends StatelessWidget {
  final String label;
  const _SocialPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppThemes.getCustomTextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          weight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
