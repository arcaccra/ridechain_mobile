import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/ui/screens/auth/wallet_information.dart';
import 'package:ridex/ui/screens/driver_onboarding/driver_onboarding_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/media.dart';
import '../auth/login_screen.dart';
import '../settings/settings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthVm>();
    final rideVm = context.watch<RideProvider>();

    final user = authVm.currentUser;
    final fullName = user?.fullName ?? 'User';
    final email = user?.email ?? '';
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';

    final completedRides =
        user?.userRides?.where((r) => r.status?.toLowerCase() == 'completed').length ?? 0;

    final balance = authVm.userWallet?.balance?.ada;
    final address = authVm.userWallet?.address ?? authVm.walletAddress ?? '';
    final shortAddress = address.length > 20
        ? '${address.substring(0, 12)}...${address.substring(address.length - 8)}'
        : address;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      weight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(
                        () => const Settings(),
                        transition: Transition.rightToLeft),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.settings_rounded,
                          color: AppColors.primaryColor, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            Gap(20.h),

            // ── User identity ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  // Avatar with edit badge
                  Stack(
                    children: [
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.backgroundColor, width: 2),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              color: AppColors.primaryColor, size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            weight: FontWeight.w800,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              weight: FontWeight.w400,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFF59E0B), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '4.92',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                weight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Text(
                              ' · $completedRides trips',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                weight: FontWeight.w400,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Gap(20.h),

            // ── Scrollable body ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    // Wallet card (white)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEEAF8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: AppColors.purple,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Wallet',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      weight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Get.to(
                                    () => const WalletInfo(),
                                    transition: Transition.rightToLeft),
                                child: Text(
                                  'Manage',
                                  style: AppThemes.getCustomTextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    weight: FontWeight.w600,
                                    color: AppColors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                balance != null
                                    ? balance.toStringAsFixed(2)
                                    : '—',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 32,
                                  weight: FontWeight.w800,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ADA',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  weight: FontWeight.w600,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF16A34A),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '+0.45',
                                      style: AppThemes.getCustomTextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        weight: FontWeight.w600,
                                        color: Color(0xFF16A34A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Address pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    shortAddress.isNotEmpty
                                        ? shortAddress
                                        : 'No wallet linked',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      weight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (address.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => Clipboard.setData(
                                        ClipboardData(text: address)),
                                    child: const Icon(Icons.copy_rounded,
                                        color: Color(0xFF9CA3AF), size: 16),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(12.h),

                    // Become a driver banner (lavender)
                    GestureDetector(
                      onTap: () => Get.to(
                          () => const DriverOnboardingScreen(),
                          transition: Transition.rightToLeft),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEAF8),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.purple,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  Media.car,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                  width: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Become a driver',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      weight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'Earn ADA on every trip you give',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      weight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFF6B7280), size: 20),
                          ],
                        ),
                      ),
                    ),

                    Gap(12.h),

                    // Settings menu card (white)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.person_outline_rounded,
                            label: 'Personal info',
                            subtitle: 'Name, email, phone',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.credit_card_outlined,
                            label: 'Payment methods',
                            subtitle: 'Cardano wallet',
                            onTap: () => Get.to(
                                () => const WalletInfo(),
                                transition: Transition.rightToLeft),
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.shield_outlined,
                            label: 'Privacy & security',
                            subtitle: 'Password, 2FA',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            subtitle: 'Trips, payments',
                            onTap: () {},
                          ),
                          const _Divider(),
                          _MenuItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & support',
                            subtitle: 'FAQ, contact us',
                            onTap: () {},
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    Gap(16.h),

                    // Sign out button
                    GestureDetector(
                      onTap: () async {
                        final success = await authVm.logout();
                        if (success) {
                          rideVm.resetRideState();
                          Get.offAll(() => const LoginScreen(),
                              transition: Transition.leftToRight);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout_rounded,
                                color: Color(0xFFDC2626), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Sign out',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                weight: FontWeight.w600,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(10.h),

                    Text(
                      'Ryde 1.0.2 (4)',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        weight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),

                    Gap(90.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu item ─────────────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLast;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEAF8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.purple, size: 18),
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
                      weight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    subtitle,
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
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Color(0xFFF3F4F6), height: 1),
    );
  }
}
