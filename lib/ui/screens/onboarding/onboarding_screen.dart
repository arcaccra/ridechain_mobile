import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ridex/core/core_constants/label.dart';
import 'package:ridex/ui/screens/landing/landing_screen.dart';
import 'package:ridex/ui/screens/onboarding/widgets/indicator_and_skip.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page_one_stack.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page_three_stack.dart';
import 'package:ridex/ui/screens/onboarding/widgets/onboarding_page_two_stack.dart';

import '../../../core/cache_helper.dart';
import '../../../core/core_constants/colors.dart';
import '../../../app/theme.dart';
import '../../shared_widgets/default_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.04.sh),
          child: Column(
            children: [
              Gap(30.h),
              Text(
                Label.appNameLabel,
                style: AppThemes.getCustomTextStyle(
                    fontSize: 24,
                    fontFamily: "Outfit",
                    weight: FontWeight.w700,
                    color: AppColors.primaryColor
                ),
                textAlign: TextAlign.center,
              ),
              Gap(0.06.sh),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  children: [
                    OnBoardingPage(title: Label.splashScreenOnboardingFirstLabel,  stack: OnboardingPageOneStack()),
                    OnBoardingPage(title: Label.splashScreenOnboardingSecondLabel,  stack: OnboardingPageTwoStack()),
                    OnBoardingPage(title: Label.splashScreenOnboardingThirdLabel,  stack: OnBoardingPageThreeStack())
                  ],
                ),
              ),
              IndicatorAndSkip(
                page: pageIndex,
                onTap: () {
                  //TODO: skip and move to login screen
                },
              ),
              const Gap(16),
              if(pageIndex == 2) DefaultButton(
                btnColor: AppColors.purple,
                btnTextColor: AppColors.white,
                onBtnTap:
                    pageIndex == 2
                        ? () {
                          CacheHelper.instance.cacheFirstTimer();
                          Get.offAll(() => const LandingScreen());
                        }
                        : () {
                          pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        },
                btnText: pageIndex == 2 ? Label.buttonContinueLabel : Label.buttonNextLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
