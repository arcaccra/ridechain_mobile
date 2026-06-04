import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ridex/core/utility.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _infoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  final ValueNotifier<Country?> _countryNotifier = ValueNotifier(null);
  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Password strength state
  bool get _hasLength => _passwordCtrl.text.length >= 8;
  bool get _hasNumberOrSymbol =>
      RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]').hasMatch(_passwordCtrl.text);
  bool get _passwordsMatch =>
      _passwordCtrl.text.isNotEmpty &&
      _passwordCtrl.text == _confirmPasswordCtrl.text;

  late AuthVm _authVm;

  @override
  void initState() {
    super.initState();
    _authVm = context.read<AuthVm>();
    _passwordCtrl.addListener(() => setState(() {}));
    _confirmPasswordCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _countryNotifier.dispose();
    _pageController.dispose();
    _authVm.clearBodyAndImages();
    super.dispose();
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  Future<void> _next() async {
    if (_currentPage == 0) {
      // Photo page — always allow skip/continue
      _authVm.addToRegisterMap('avatar', _authVm.selectedFile);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 1) {
      if (!_infoFormKey.currentState!.validate()) return;
      if (_countryNotifier.value == null) return;
      FocusManager.instance.primaryFocus?.unfocus();
      final country = _countryNotifier.value!;
      final formatted = '+${country.phoneCode}${toNumericString(_phoneCtrl.text)}';
      _authVm.addToRegisterMap('phone_number', formatted);
      _authVm.addToRegisterMap('email', _emailCtrl.text.trim());
      _authVm.addToRegisterMap('full_name', _nameCtrl.text.trim());
      _authVm.addToRegisterMap('country', country.countryCode);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 2) {
      if (!_passwordFormKey.currentState!.validate()) return;
      if (!_hasLength || !_hasNumberOrSymbol || !_passwordsMatch) return;
      _authVm.addToRegisterMap('password1', _passwordCtrl.text.trim());
      _authVm.addToRegisterMap('password2', _confirmPasswordCtrl.text.trim());
      await _authVm.register();
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    _authVm = context.watch<AuthVm>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar: back + progress
                Padding(
                  padding: EdgeInsets.only(
                      top: 8.h, left: 8.w, right: 24.w, bottom: 4.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20),
                        color: AppColors.primaryColor,
                        onPressed: _previousPage,
                      ),
                    ],
                  ),
                ),

                // Progress bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / 4,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.purple),
                      minHeight: 4,
                    ),
                  ),
                ),

                Gap(4.h),

                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (p) => setState(() => _currentPage = p),
                    children: [
                      _PhotoPage(),
                      _InfoPage(),
                      _PasswordPage(),
                    ],
                  ),
                ),

                // Bottom button
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: _currentPage == 0 && _authVm.imageFile == null
                      ? _SkipLink(onTap: _next)
                      : DefaultButton(
                          onBtnTap: _next,
                          btnText: _currentPage == 1
                              ? 'Send verification code'
                              : 'Continue',
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

  // ─── PAGE 0: Photo ───────────────────────────────────────────────────────

  Widget _PhotoPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(24.h),
          Text(
            'Add a profile photo',
            style: AppThemes.getCustomTextStyle(
              fontFamily: 'Outfit',
              fontSize: 28,
              weight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ).animate().fade(begin: 0, end: 1, duration: 400.ms),

          Gap(6.h),
          Text(
            'Help your driver recognize you at pickup.',
            style: AppThemes.getCustomTextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              weight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
          ).animate(delay: 60.ms).fade(begin: 0, end: 1, duration: 400.ms),

          Gap(36.h),

          // Avatar preview
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEDE8FA),
                  ),
                  child: _authVm.imageFile != null
                      ? ClipOval(
                          child: Image.file(
                            File(_authVm.imageFile!.path),
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : const Icon(
                          Icons.person_outline_rounded,
                          size: 64,
                          color: AppColors.purple,
                        ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purple,
                    ),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ).animate(delay: 80.ms).fade(begin: 0, end: 1, duration: 400.ms).scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              duration: 400.ms,
              curve: Curves.easeOut),

          Gap(36.h),

          // Take a photo option
          _PhotoOption(
            icon: Icons.camera_alt_outlined,
            title: 'Take a photo',
            subtitle: 'Use your camera',
            onTap: () async {
              await _authVm.captureProfilePicture(context,
                  source: ImageSource.camera);
            },
          ).animate(delay: 140.ms).fade(begin: 0, end: 1, duration: 400.ms),

          Gap(12.h),

          // Choose from gallery option
          _PhotoOption(
            icon: Icons.image_outlined,
            title: 'Choose from gallery',
            subtitle: 'Pick an existing photo',
            onTap: () async {
              await _authVm.captureProfilePicture(context,
                  source: ImageSource.gallery);
            },
          ).animate(delay: 180.ms).fade(begin: 0, end: 1, duration: 400.ms),

          Gap(24.h),
        ],
      ),
    );
  }

  // ─── PAGE 1: Personal info ────────────────────────────────────────────────

  Widget _InfoPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Form(
        key: _infoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(24.h),
            Text(
              'Tell us about you',
              style: AppThemes.getCustomTextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                weight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ).animate().fade(begin: 0, end: 1, duration: 400.ms),

            Gap(6.h),
            Text(
              'We\'ll verify your phone with a quick code.',
              style: AppThemes.getCustomTextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                weight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ).animate(delay: 60.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(28.h),

            _FieldLabel('Full name'),
            Gap(6.h),
            CustomTextField(
              controller: _nameCtrl,
              hintText: 'Kwame Mensah',
              keyboardType: TextInputType.name,
              fillColor: const Color(0xFFEEEAF8),
              prefixIcon: const Icon(Icons.person_outline_rounded,
                  color: Color(0xFF9CA3AF), size: 20),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name is required'
                  : null,
            ).animate(delay: 100.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(16.h),
            _FieldLabel('Email'),
            Gap(6.h),
            CustomTextField(
              controller: _emailCtrl,
              hintText: 'kwame@arc.app',
              keyboardType: TextInputType.emailAddress,
              fillColor: const Color(0xFFEEEAF8),
              prefixIcon: const Icon(Icons.info_outline_rounded,
                  color: Color(0xFF9CA3AF), size: 20),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!Utils.emailRegex.hasMatch(v)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ).animate(delay: 140.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(16.h),
            _FieldLabel('Phone number'),
            Gap(6.h),
            _PhoneRow(
              countryNotifier: _countryNotifier,
              phoneController: _phoneCtrl,
            ).animate(delay: 180.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(16.h),
            _FieldLabel('Country'),
            Gap(6.h),
            ValueListenableBuilder<Country?>(
              valueListenable: _countryNotifier,
              builder: (_, country, __) {
                return GestureDetector(
                  onTap: () => showCountryPicker(
                    context: context,
                    onSelect: (c) => _countryNotifier.value = c,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEAF8),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          country == null
                              ? '🌍  Select country'
                              : '${country.flagEmoji}  ${country.name}',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            weight: FontWeight.w400,
                            color: country == null
                                ? const Color(0xFF9CA3AF)
                                : AppColors.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF9CA3AF), size: 22),
                      ],
                    ),
                  ),
                );
              },
            ).animate(delay: 220.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(16.h),

            // Info note
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEAF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.purple, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'We\'ll send a 6-digit code to verify your number. Standard SMS rates apply.',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        weight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 260.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(24.h),
          ],
        ),
      ),
    );
  }

  // ─── PAGE 2: Password ─────────────────────────────────────────────────────

  Widget _PasswordPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Form(
        key: _passwordFormKey,
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
            ).animate(delay: 60.ms).fade(begin: 0, end: 1, duration: 400.ms),

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
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ).animate(delay: 100.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(16.h),

            _FieldLabel('Confirm password'),
            Gap(6.h),
            CustomTextField(
              controller: _confirmPasswordCtrl,
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
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) => v != _passwordCtrl.text
                  ? 'Passwords do not match'
                  : null,
            ).animate(delay: 140.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(20.h),

            // Validation indicators
            _ValidationIndicator(
              met: _hasLength,
              label: '8+ characters',
            ).animate(delay: 180.ms).fade(begin: 0, end: 1, duration: 400.ms),
            Gap(8.h),
            _ValidationIndicator(
              met: _hasNumberOrSymbol,
              label: 'A number or symbol',
            ).animate(delay: 210.ms).fade(begin: 0, end: 1, duration: 400.ms),
            Gap(8.h),
            _ValidationIndicator(
              met: _passwordsMatch,
              label: 'Matches confirmation',
            ).animate(delay: 240.ms).fade(begin: 0, end: 1, duration: 400.ms),

            Gap(24.h),
          ],
        ),
      ),
    );
  }
}

// ─── Small shared widgets ─────────────────────────────────────────────────────

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

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PhotoOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEAF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.purple, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        weight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        weight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      )),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF), size: 22),
          ],
        ),
      ),
    );
  }
}

class _SkipLink extends StatelessWidget {
  final VoidCallback onTap;
  const _SkipLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          'Skip for now',
          style: AppThemes.getCustomTextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            weight: FontWeight.w500,
            color: AppColors.purple,
          ),
        ),
      ),
    );
  }
}

/// Phone row with country code picker on left and number input on right.
class _PhoneRow extends StatelessWidget {
  final ValueNotifier<Country?> countryNotifier;
  final TextEditingController phoneController;

  const _PhoneRow(
      {required this.countryNotifier, required this.phoneController});

  void _pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      onSelect: (c) => countryNotifier.value = c,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Country?>(
      valueListenable: countryNotifier,
      builder: (context, country, _) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEEAF8),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              // Country code picker
              GestureDetector(
                onTap: () => _pickCountry(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18.h),
                  child: Row(
                    children: [
                      Text(
                        country == null
                            ? '🌍'
                            : country.flagEmoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        country == null ? '+--' : '+${country.phoneCode}',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          weight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF9CA3AF), size: 18),
                    ],
                  ),
                ),
              ),

              // Divider
              Container(width: 1, height: 28, color: const Color(0xFFD1D5DB)),

              // Phone number input
              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  readOnly: country == null,
                  onTap: () {
                    if (country == null) _pickCountry(context);
                  },
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    weight: FontWeight.w400,
                    color: AppColors.primaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: '24 555 0123',
                    hintStyle: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      weight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 18.h),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Phone number required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
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
