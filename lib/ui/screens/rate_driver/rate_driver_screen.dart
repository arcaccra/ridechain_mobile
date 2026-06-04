import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../providers/rides_provider.dart';
import '../../shared_widgets/loader.dart';

class RateDriverScreen extends StatefulWidget {
  const RateDriverScreen({super.key});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  final TextEditingController _reviewCtrl = TextEditingController();
  final Set<String> _selectedTags = {};
  int _rating = 0;

  static const _tags = [
    'Friendly',
    'Punctual',
    'Safe driver',
    'Good music',
    'Comfortable',
    'Clean car',
  ];

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideProvider = context.watch<RideProvider>();
    final driver = rideProvider.selectedRide?.driver;
    final driverName = driver?.user?.fullName ?? 'Driver';
    final firstName = driverName.split(' ').first;
    final initial =
        driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Close button
                Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 8.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22),
                      color: AppColors.primaryColor,
                      onPressed: () => _skip(rideProvider),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        Gap(16.h),

                        // Driver avatar
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.purple,
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        Gap(16.h),

                        Text(
                          'How was your trip with $firstName?',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            weight: FontWeight.w800,
                            color: AppColors.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        Gap(6.h),

                        Text(
                          'Your rating helps the community',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            weight: FontWeight.w400,
                            color: const Color(0xFF9CA3AF),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        Gap(28.h),

                        // Star row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final filled = i < _rating;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _rating = i + 1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                child: Icon(
                                  filled
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 44,
                                  color: filled
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFFD1D5DB),
                                ),
                              ),
                            );
                          }),
                        ),

                        // Tags + note — only visible once a rating is chosen
                        if (_rating > 0) ...[
                          Gap(28.h),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'What stood out?',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                weight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),

                          Gap(12.h),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _tags.map((tag) {
                              final selected =
                                  _selectedTags.contains(tag);
                              return GestureDetector(
                                onTap: () => setState(() {
                                  selected
                                      ? _selectedTags.remove(tag)
                                      : _selectedTags.add(tag);
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.purple
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.purple
                                          : const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      weight: FontWeight.w500,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          Gap(24.h),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Add a note (optional)',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                weight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ),

                          Gap(8.h),

                          TextField(
                            controller: _reviewCtrl,
                            minLines: 3,
                            maxLines: 5,
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              weight: FontWeight.w400,
                              color: AppColors.primaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  "Anything you'd like to share?",
                              hintStyle: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                weight: FontWeight.w400,
                                color: const Color(0xFF9CA3AF),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFEEEAF8),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.circular(14.r),
                              ),
                              contentPadding: const EdgeInsets.all(14),
                            ),
                          ),
                        ],

                        Gap(24.h),
                      ],
                    ),
                  ),
                ),

                // Bottom buttons
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _rating > 0
                              ? () => _submit(rideProvider)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            disabledBackgroundColor:
                                AppColors.purple.withValues(alpha: 0.35),
                            padding: const EdgeInsets.symmetric(
                                vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Submit rating',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              weight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _skip(rideProvider),
                        child: Text(
                          'Skip',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            weight: FontWeight.w500,
                            color: AppColors.purple,
                          ),
                        ),
                      ),
                      Gap(8.h),
                    ],
                  ),
                ),
              ],
            ),

            if (rideProvider.isLoading) const Loader(),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(RideProvider rideProvider) async {
    final body = {
      'ride': rideProvider.selectedRide?.uuid,
      'score': _rating.toDouble(),
      'comment': _reviewCtrl.text.trim(),
      'impression_option': _selectedTags.isNotEmpty
          ? _selectedTags.first
          : null,
    };
    log(body.toString());
    final success = await rideProvider.rateTrip(body);
    if (!mounted) return;
    if (success) {
      rideProvider.resetRideState();
      Get.offAll(() => const AppNavigationScreen(),
          transition: Transition.leftToRight);
    }
  }

  void _skip(RideProvider rideProvider) {
    rideProvider.resetRideState();
    Get.offAll(() => const AppNavigationScreen(),
        transition: Transition.leftToRight);
  }
}
