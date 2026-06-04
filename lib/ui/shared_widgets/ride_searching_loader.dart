import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme.dart';
import '../../core/core_constants/colors.dart';
import '../../core/core_constants/media.dart';
import 'package:flutter_svg/svg.dart';

class RideSearchingLoader extends StatefulWidget {
  const RideSearchingLoader({
    super.key,
    this.title,
    this.fontSize,
    this.noLoadingText,
    this.height,
    this.onBtnTap,
    this.notLoadingState = false,
    this.lowerBtnText,
    this.destination,
  });

  final String? title;
  final String? lowerBtnText;
  final String? noLoadingText;
  final VoidCallback? onBtnTap;
  final bool notLoadingState;
  final double? height;
  final double? fontSize;
  final String? destination;

  @override
  State<RideSearchingLoader> createState() => _RideSearchingLoaderState();
}

class _RideSearchingLoaderState extends State<RideSearchingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notLoadingState) {
      return _buildNotLoadingState();
    }
    return _buildSearchingState();
  }

  Widget _buildSearchingState() {
    final dest = widget.destination ?? '';
    return SizedBox(
      width: double.infinity,
      height: widget.height ?? 0.5.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsing concentric circles with car icon
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              return SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring (most transparent)
                    _Ring(
                      size: 160,
                      opacity: 0.15 + _pulse.value * 0.1,
                    ),
                    // Middle ring
                    _Ring(
                      size: 120,
                      opacity: 0.25 + _pulse.value * 0.15,
                    ),
                    // Inner filled circle
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.purple,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Media.car,
                          width: 32,
                          height: 32,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          Text(
            widget.title ?? 'Finding rides…',
            style: AppThemes.getCustomTextStyle(
              fontFamily: 'Outfit',
              fontSize: widget.fontSize ?? 22,
              weight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),

          if (dest.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'to $dest',
              style: AppThemes.getCustomTextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                weight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Cancel button
          GestureDetector(
            onTap: widget.onBtnTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEAF8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.lowerBtnText ?? 'Cancel',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  weight: FontWeight.w600,
                  color: AppColors.purple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoadingState() {
    return SizedBox(
      width: double.infinity,
      height: widget.height ?? 0.4.sh,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEEEAF8),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Media.car,
                  width: 36,
                  height: 36,
                  colorFilter: const ColorFilter.mode(
                      AppColors.purple, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title ?? 'Your ride is here!',
              style: AppThemes.getCustomTextStyle(
                fontFamily: 'Outfit',
                fontSize: widget.fontSize ?? 20,
                weight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onBtnTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.noLoadingText ?? 'Confirm',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    weight: FontWeight.w600,
                    color: Colors.white,
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

class _Ring extends StatelessWidget {
  final double size;
  final double opacity;
  const _Ring({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.purple.withValues(alpha: opacity),
          width: 1.5,
        ),
      ),
    );
  }
}
