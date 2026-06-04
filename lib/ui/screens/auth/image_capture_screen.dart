import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';

class ImageCaptureScreen extends StatelessWidget {
  const ImageCaptureScreen({super.key});

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(8.h),

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
                        ).animate(delay: 60.ms)
                            .fade(begin: 0, end: 1, duration: 400.ms),

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
                                child: authVm.imageFile != null
                                    ? ClipOval(
                                        child: Image.file(
                                          File(authVm.imageFile!.path),
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
                        )
                            .animate(delay: 80.ms)
                            .fade(begin: 0, end: 1, duration: 400.ms)
                            .scale(
                                begin: const Offset(0.9, 0.9),
                                end: const Offset(1, 1),
                                duration: 400.ms,
                                curve: Curves.easeOut),

                        Gap(36.h),

                        // Take a photo
                        _PhotoOption(
                          icon: Icons.camera_alt_outlined,
                          title: 'Take a photo',
                          subtitle: 'Use your camera',
                          onTap: () async {
                            await authVm.captureProfilePicture(context,
                                source: ImageSource.camera);
                          },
                        ).animate(delay: 140.ms)
                            .fade(begin: 0, end: 1, duration: 400.ms),

                        Gap(12.h),

                        // Choose from gallery
                        _PhotoOption(
                          icon: Icons.image_outlined,
                          title: 'Choose from gallery',
                          subtitle: 'Pick an existing photo',
                          onTap: () async {
                            await authVm.captureProfilePicture(context,
                                source: ImageSource.gallery);
                          },
                        ).animate(delay: 180.ms)
                            .fade(begin: 0, end: 1, duration: 400.ms),

                        Gap(24.h),
                      ],
                    ),
                  ),
                ),

                // Bottom button
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: authVm.imageFile == null
                      ? Center(
                          child: GestureDetector(
                            onTap: () async {
                              authVm.addToRegisterMap('avatar', null);
                              await authVm.register();
                            },
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
                        )
                      : DefaultButton(
                          onBtnTap: () async {
                            authVm.addToRegisterMap(
                                'avatar', authVm.selectedFile);
                            await authVm.register();
                          },
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
