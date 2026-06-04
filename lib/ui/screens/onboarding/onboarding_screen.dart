import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ridex/ui/screens/landing/landing_screen.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page_one_stack.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page_three_stack.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page_two_stack.dart';

import '../../../core/cache_helper.dart';
import '../../../core/core_constants/colors.dart';
import '../../../app/theme.dart';
import '../../shared_widgets/default_button.dart';
import 'widgets/dot_indicator_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skip() {
    CacheHelper.instance.cacheFirstTimer();
    Get.offAll(() => const LandingScreen());
  }

  void _next() {
    if (_pageIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      CacheHelper.instance.cacheFirstTimer();
      Get.offAll(() => const LandingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button row
            Padding(
              padding: EdgeInsets.only(top: 8.h, right: 24.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: _pageIndex < 2
                    ? GestureDetector(
                        onTap: _skip,
                        child: Text(
                          'Skip',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            weight: FontWeight.w500,
                            color: AppColors.purple,
                          ),
                        ),
                      )
                    : const SizedBox(height: 24),
              ),
            ),

            // PageView — takes all remaining space above the bottom controls
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                children: const [
                  OnBoardingPage(
                    title: 'Carpool, on your terms',
                    subtitle:
                        'Find a seat with someone going your way. Smart matching across the city — no surge, no middleman.',
                    illustration: OnboardingPageOneStack(),
                  ),
                  OnBoardingPage(
                    title: 'Pay in ADA',
                    subtitle:
                        'Fares settle directly on Cardano. No card details, no hidden fees. Just a wallet and a destination.',
                    illustration: OnboardingPageTwoStack(),
                  ),
                  OnBoardingPage(
                    title: 'Verified rides, real rewards',
                    subtitle:
                        'Scan your trip QR to earn ADA — a small thank-you every time you take a verified ride.',
                    illustration: OnBoardingPageThreeStack(),
                  ),
                ],
              ),
            ),

            // Dot indicators
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: DotIndicatorWidget(page: _pageIndex, dotCount: 3),
            ),

            // Action button
            Padding(
              padding:
                  EdgeInsets.only(left: 24.w, right: 24.w, bottom: 32.h),
              child: DefaultButton(
                btnColor: AppColors.purple,
                btnTextColor: AppColors.white,
                btnText: _pageIndex == 2 ? 'Get Started  →' : 'Next  →',
                onBtnTap: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

