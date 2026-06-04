import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../core/core_constants/colors.dart';

class DotIndicatorWidget extends StatelessWidget {
  const DotIndicatorWidget(
      {super.key, required this.page, required this.dotCount});

  final int page;
  final int dotCount;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: dotCount == 0 ? 1 : dotCount,
      position: page.toDouble(),
      mainAxisAlignment: MainAxisAlignment.center,
      decorator: DotsDecorator(
        color: const Color(0xFFD1D5DB),
        size: const Size.square(8.0),
        activeSize: const Size(24.0, 8.0),
        activeColor: AppColors.purple,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
