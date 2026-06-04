import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/media.dart';

class DriverOnboardingScreen extends StatefulWidget {
  const DriverOnboardingScreen({super.key});

  @override
  State<DriverOnboardingScreen> createState() => _DriverOnboardingScreenState();
}

class _DriverOnboardingScreenState extends State<DriverOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0; // 0-indexed; 3 steps + 1 success
  static const int _totalSteps = 3;

  // Step 1 — vehicle
  final _makeCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();

  // Step 2 — identity
  String _idType = 'National ID';
  final _idNumberCtrl = TextEditingController();
  File? _idFront;
  File? _idBack;

  // Step 3 — documents
  File? _license;
  File? _insurance;

  @override
  void dispose() {
    _pageController.dispose();
    _makeCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _colorCtrl.dispose();
    _plateCtrl.dispose();
    _idNumberCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) return File(picked.path);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _Step1Vehicle(
              makeCtrl: _makeCtrl,
              modelCtrl: _modelCtrl,
              yearCtrl: _yearCtrl,
              colorCtrl: _colorCtrl,
              plateCtrl: _plateCtrl,
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _back,
              onNext: _next,
            ),
            _Step2Identity(
              idType: _idType,
              idNumberCtrl: _idNumberCtrl,
              idFront: _idFront,
              idBack: _idBack,
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onIdTypeChanged: (v) => setState(() => _idType = v),
              onPickFront: () async {
                final f = await _pickImage();
                if (f != null) setState(() => _idFront = f);
              },
              onPickBack: () async {
                final f = await _pickImage();
                if (f != null) setState(() => _idBack = f);
              },
              onBack: _back,
              onNext: _next,
            ),
            _Step3Documents(
              license: _license,
              insurance: _insurance,
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onPickLicense: () async {
                final f = await _pickImage();
                if (f != null) setState(() => _license = f);
              },
              onPickInsurance: () async {
                final f = await _pickImage();
                if (f != null) setState(() => _insurance = f);
              },
              onBack: _back,
              onSubmit: _next,
            ),
            const _SuccessScreen(),
          ],
        ),
      ),
    );
  }
}

// ── Progress bar ──────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final int current; // 1-indexed
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: current / total,
      backgroundColor: const Color(0xFFE5E7EB),
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple),
      minHeight: 3,
    );
  }
}

// ── Bottom row (Back + primary button) ───────────────────────────────────────
class _BottomRow extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onPrimary;
  final String primaryLabel;

  const _BottomRow({
    required this.onBack,
    required this.onPrimary,
    required this.primaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Center(
                child: Text(
                  'Back',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    weight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Primary button
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: onPrimary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  primaryLabel,
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upload card (dashed lavender border) ──────────────────────────────────────
class _UploadCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final File? file;
  final VoidCallback onTap;

  const _UploadCard({
    required this.label,
    required this.subtitle,
    this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEAF8),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.purple.withValues(alpha: 0.4),
            width: 1.5,
            // dashed appearance approximated with a thin lavender border
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(file!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.camera_alt_outlined,
                      color: AppColors.purple, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      weight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    file != null ? 'Tap to replace' : subtitle,
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      weight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              file != null ? Icons.check_circle_rounded : Icons.add_rounded,
              color: file != null ? const Color(0xFF16A34A) : AppColors.purple,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Vehicle info ──────────────────────────────────────────────────────
class _Step1Vehicle extends StatelessWidget {
  final TextEditingController makeCtrl;
  final TextEditingController modelCtrl;
  final TextEditingController yearCtrl;
  final TextEditingController colorCtrl;
  final TextEditingController plateCtrl;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _Step1Vehicle({
    required this.makeCtrl,
    required this.modelCtrl,
    required this.yearCtrl,
    required this.colorCtrl,
    required this.plateCtrl,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProgressBar(current: 1, total: totalSteps),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your vehicle',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    weight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                Gap(6.h),
                Text(
                  'Tell us about the car you\'ll be driving.',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                Gap(28.h),
                _FieldLabel('Make'),
                Gap(6.h),
                _Field(controller: makeCtrl, hint: 'e.g. Toyota'),
                Gap(16.h),
                _FieldLabel('Model'),
                Gap(6.h),
                _Field(controller: modelCtrl, hint: 'e.g. Corolla'),
                Gap(16.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('Year'),
                          Gap(6.h),
                          _Field(
                            controller: yearCtrl,
                            hint: '2020',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('Color'),
                          Gap(6.h),
                          _Field(controller: colorCtrl, hint: 'Silver'),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                _FieldLabel('Plate number'),
                Gap(6.h),
                _Field(
                  controller: plateCtrl,
                  hint: 'GR 1234-22',
                ),
                Gap(24.h),
              ],
            ),
          ),
        ),
        _BottomRow(
          onBack: onBack,
          onPrimary: onNext,
          primaryLabel: 'Continue',
        ),
      ],
    );
  }
}

// ── Step 2: Verify identity ───────────────────────────────────────────────────
class _Step2Identity extends StatelessWidget {
  final String idType;
  final TextEditingController idNumberCtrl;
  final File? idFront;
  final File? idBack;
  final int currentStep;
  final int totalSteps;
  final ValueChanged<String> onIdTypeChanged;
  final VoidCallback onPickFront;
  final VoidCallback onPickBack;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _Step2Identity({
    required this.idType,
    required this.idNumberCtrl,
    required this.idFront,
    required this.idBack,
    required this.currentStep,
    required this.totalSteps,
    required this.onIdTypeChanged,
    required this.onPickFront,
    required this.onPickBack,
    required this.onBack,
    required this.onNext,
  });

  static const _idTypes = [
    'National ID',
    'Passport',
    "Driver's License",
    'Voter ID',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProgressBar(current: 2, total: totalSteps),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify your identity',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    weight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                Gap(6.h),
                Text(
                  'We need a government ID to keep the platform safe.',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                Gap(28.h),

                _FieldLabel('ID type'),
                Gap(6.h),
                // Dropdown
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: idType,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primaryColor),
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        weight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                      items: _idTypes
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) onIdTypeChanged(v);
                      },
                    ),
                  ),
                ),

                Gap(16.h),
                _FieldLabel('ID number'),
                Gap(6.h),
                _Field(controller: idNumberCtrl, hint: 'GHA-712345678'),

                Gap(20.h),
                _UploadCard(
                  label: 'ID front',
                  subtitle: 'Full image, no glare',
                  file: idFront,
                  onTap: onPickFront,
                ),
                Gap(12.h),
                _UploadCard(
                  label: 'ID back',
                  subtitle: 'Must be readable',
                  file: idBack,
                  onTap: onPickBack,
                ),
                Gap(24.h),
              ],
            ),
          ),
        ),
        _BottomRow(
          onBack: onBack,
          onPrimary: onNext,
          primaryLabel: 'Continue',
        ),
      ],
    );
  }
}

// ── Step 3: Driver documents ──────────────────────────────────────────────────
class _Step3Documents extends StatelessWidget {
  final File? license;
  final File? insurance;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onPickLicense;
  final VoidCallback onPickInsurance;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const _Step3Documents({
    required this.license,
    required this.insurance,
    required this.currentStep,
    required this.totalSteps,
    required this.onPickLicense,
    required this.onPickInsurance,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProgressBar(current: 3, total: totalSteps),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver documents',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    weight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                Gap(6.h),
                Text(
                  'Upload your license and current insurance.',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                Gap(24.h),

                _UploadCard(
                  label: "Driver's license",
                  subtitle: 'Both sides combined',
                  file: license,
                  onTap: onPickLicense,
                ),
                Gap(12.h),
                _UploadCard(
                  label: 'Insurance certificate',
                  subtitle: 'Must be current',
                  file: insurance,
                  onTap: onPickInsurance,
                ),

                Gap(16.h),

                // Privacy notice
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEAF8),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined,
                          color: AppColors.purple, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Documents are encrypted end-to-end and only used for verification.',
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
                ),

                Gap(24.h),
              ],
            ),
          ),
        ),
        _BottomRow(
          onBack: onBack,
          onPrimary: onSubmit,
          primaryLabel: 'Submit application',
        ),
      ],
    );
  }
}

// ── Success screen ────────────────────────────────────────────────────────────
class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Purple car circle
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purple,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Media.car,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                            width: 48,
                          ),
                        ),
                      ),

                      Gap(28.h),

                      Text(
                        'Application submitted',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 28,
                          weight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Gap(10.h),

                      Text(
                        "We'll review your documents within 24 hours. You'll get a push when you're approved.",
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          weight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Gap(32.h),

                      // Steps card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Column(
                          children: [
                            _StepRow(
                              index: 1,
                              label: 'Documents received',
                              isDone: true,
                            ),
                            Gap(16.h),
                            _StepRow(
                              index: 2,
                              label: 'Identity verification',
                              isDone: false,
                            ),
                            Gap(16.h),
                            _StepRow(
                              index: 3,
                              label: 'Final approval',
                              isDone: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Back to home
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(
                    () => const AppNavigationScreen(),
                    transition: Transition.leftToRight,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Back to home',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
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

class _StepRow extends StatelessWidget {
  final int index;
  final String label;
  final bool isDone;

  const _StepRow(
      {required this.index, required this.label, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? const Color(0xFF16A34A)
                : Colors.white.withValues(alpha: 0.1),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : Text(
                    '$index',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      weight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: AppThemes.getCustomTextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            weight: isDone ? FontWeight.w600 : FontWeight.w400,
            color: isDone ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

// ── Shared field helpers ──────────────────────────────────────────────────────
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
        color: const Color(0xFF6B7280),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppThemes.getCustomTextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        weight: FontWeight.w500,
        color: AppColors.primaryColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppThemes.getCustomTextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          weight: FontWeight.w400,
          color: const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(14.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
          borderRadius: BorderRadius.circular(14.r),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
