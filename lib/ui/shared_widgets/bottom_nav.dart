import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_constants/colors.dart';
import '../../core/core_constants/media.dart';

class BottomNav extends StatelessWidget {
  final int? currentIndex;
  final void Function(int)? getCurrentIndex;
  const BottomNav({super.key, this.currentIndex, this.getCurrentIndex});

  static const _items = [
    _NavData(icon: Media.home, label: 'Home'),
    _NavData(icon: Media.scan, label: 'Scan'),
    _NavData(icon: Media.history, label: 'Trips'),
    _NavData(icon: Media.profile, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, left: 40.w, right: 40.w),
      child: Container(
        height: 62.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(36.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              spreadRadius: 0,
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final isActive = currentIndex == index;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => getCurrentIndex?.call(index),
              child: SizedBox(
                width: 56.w,
                height: 62.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isActive ? 42 : 36,
                      height: isActive ? 42 : 36,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.purple.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          _items[index].icon,
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            isActive
                                ? AppColors.purple
                                : const Color(0xFFB0B7C3),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavData {
  final String icon;
  final String label;
  const _NavData({required this.icon, required this.label});
}
