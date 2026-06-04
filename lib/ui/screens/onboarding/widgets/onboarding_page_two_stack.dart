import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/core_constants/colors.dart';
import '../../../../app/theme.dart';

/// Slide 2 — "Pay in ADA"
/// Lavender circle with a dark ADA wallet card and floating ADA coin bubbles.
class OnboardingPageTwoStack extends StatelessWidget {
  const OnboardingPageTwoStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lavender background circle
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEDE8FA),
              ),
            )
                .animate()
                .fade(begin: 0, end: 1, duration: 500.ms)
                .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOut),

            // ADA wallet card
            Positioned(
              top: 60,
              left: 40,
              right: 40,
              child: _AdaWalletCard()
                  .animate(delay: 150.ms)
                  .fade(begin: 0, end: 1, duration: 450.ms)
                  .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 450.ms,
                      curve: Curves.easeOut),
            ),

            // Floating ADA coin — bottom-left
            Positioned(
              bottom: 55,
              left: 28,
              child: const _AdaCoin(size: 44, alpha: 1.0)
                  .animate(delay: 280.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms)
                  .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 400.ms),
            ),

            // Floating ADA coin — smaller, lighter
            Positioned(
              bottom: 35,
              left: 90,
              child: const _AdaCoin(size: 32, alpha: 0.45)
                  .animate(delay: 340.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms)
                  .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 400.ms),
            ),

            // Floating ADA coin — bottom-right
            Positioned(
              bottom: 50,
              right: 28,
              child: const _AdaCoin(size: 44, alpha: 1.0)
                  .animate(delay: 310.ms)
                  .fade(begin: 0, end: 1, duration: 400.ms)
                  .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 400.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdaWalletCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADA WALLET',
            style: AppThemes.getCustomTextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              weight: FontWeight.w500,
              color: const Color(0xFF9CA3AF),
              spacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '125.50 ',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 30,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '₳',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  weight: FontWeight.w400,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'addr1q...8x2pn',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  weight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdaCoin extends StatelessWidget {
  final double size;
  final double alpha;

  const _AdaCoin({required this.size, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.purple.withValues(alpha: alpha),
      ),
      alignment: Alignment.center,
      child: Text(
        '₳',
        style: AppThemes.getCustomTextStyle(
          fontFamily: 'Inter',
          fontSize: size * 0.42,
          weight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
