import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/ui/screens/auth/image_capture_screen.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _hasLength => _passwordCtrl.text.length >= 8;
  bool get _hasNumberOrSymbol =>
      RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]').hasMatch(_passwordCtrl.text);
  bool get _passwordsMatch =>
      _passwordCtrl.text.isNotEmpty &&
      _passwordCtrl.text == _confirmCtrl.text;

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit(AuthVm authVm) {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasLength || !_hasNumberOrSymbol || !_passwordsMatch) return;
    authVm.addToRegisterMap('password1', _passwordCtrl.text.trim());
    authVm.addToRegisterMap('password2', _confirmCtrl.text.trim());
    Get.to(() => const ImageCaptureScreen(), transition: Transition.leftToRight);
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
                      value: 3 / 4,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(24.h),

                          Text(
                            'Create a password',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 28,
                              weight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ).animate().fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(6.h),
                          Text(
                            'You\'ll use this to sign in next time.',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              weight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ).animate(delay: 60.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(28.h),

                          _FieldLabel('Password'),
                          Gap(6.h),
                          CustomTextField(
                            controller: _passwordCtrl,
                            hintText: '••••••••••',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscurePassword,
                            fillColor: const Color(0xFFEEEAF8),
                            prefixIcon: const Icon(Icons.shield_outlined,
                                color: Color(0xFF9CA3AF), size: 20),
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
                          ).animate(delay: 100.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(16.h),

                          _FieldLabel('Confirm password'),
                          Gap(6.h),
                          CustomTextField(
                            controller: _confirmCtrl,
                            hintText: '••••••••••',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureConfirm,
                            fillColor: const Color(0xFFEEEAF8),
                            prefixIcon: const Icon(Icons.check_rounded,
                                color: Color(0xFF9CA3AF), size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF9CA3AF),
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                            validator: (v) => v != _passwordCtrl.text
                                ? 'Passwords do not match'
                                : null,
                          ).animate(delay: 140.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(20.h),

                          _ValidationIndicator(met: _hasLength, label: '8+ characters')
                              .animate(delay: 180.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),
                          Gap(8.h),
                          _ValidationIndicator(
                                  met: _hasNumberOrSymbol,
                                  label: 'A number or symbol')
                              .animate(delay: 210.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),
                          Gap(8.h),
                          _ValidationIndicator(
                                  met: _passwordsMatch,
                                  label: 'Matches confirmation')
                              .animate(delay: 240.ms)
                              .fade(begin: 0, end: 1, duration: 400.ms),

                          Gap(24.h),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: DefaultButton(
                    onBtnTap: () => _submit(authVm),
                    btnText: 'Continue',
                    btnColor: AppColors.purple,
                    btnTextColor: AppColors.white,
                  ),
                ),
              ],
            ),

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
  Widget build(BuildContext context) => Text(
        text,
        style: AppThemes.getCustomTextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          weight: FontWeight.w500,
          color: const Color(0xFF374151),
        ),
      );
}

class _ValidationIndicator extends StatelessWidget {
  final bool met;
  final String label;
  const _ValidationIndicator({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: met ? const Color(0xFF22C55E) : Colors.transparent,
            border: met
                ? null
                : Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
          ),
          child: met
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppThemes.getCustomTextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            weight: FontWeight.w400,
            color: met ? const Color(0xFF22C55E) : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
