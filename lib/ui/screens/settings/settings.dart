import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/ui/screens/auth/wallet_information.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notifications = true;
  bool _shareLocation = true;
  bool _biometric = false;
  bool _darkMode = false;
  bool _autoPay = true;

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthVm>();
    final address = authVm.userWallet?.address ?? authVm.walletAddress ?? '';
    final shortAddress = address.length > 10
        ? '${address.substring(0, 7)}...${address.substring(address.length - 3)}'
        : address;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Back bar
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 20.w, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    color: AppColors.primaryColor,
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'Settings',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      weight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            Gap(8.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── GENERAL ──────────────────────────────────────────────
                    _SectionLabel(label: 'GENERAL'),
                    Gap(8.h),
                    _SettingsCard(
                      children: [
                        _ToggleRow(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          subtitle: 'Trip updates, payments',
                          value: _notifications,
                          onChanged: (v) => setState(() => _notifications = v),
                        ),
                        const _CardDivider(),
                        _ToggleRow(
                          icon: Icons.location_on_outlined,
                          label: 'Share location',
                          subtitle: 'During active trips',
                          value: _shareLocation,
                          onChanged: (v) => setState(() => _shareLocation = v),
                        ),
                        const _CardDivider(),
                        _ToggleRow(
                          icon: Icons.shield_outlined,
                          label: 'Biometric sign-in',
                          subtitle: 'Face ID or fingerprint',
                          value: _biometric,
                          onChanged: (v) => setState(() => _biometric = v),
                        ),
                        const _CardDivider(),
                        _ToggleRow(
                          icon: Icons.dark_mode_outlined,
                          label: 'Dark mode',
                          value: _darkMode,
                          onChanged: (v) => setState(() => _darkMode = v),
                        ),
                      ],
                    ),

                    Gap(24.h),

                    // ── WALLET & PAYMENTS ─────────────────────────────────────
                    _SectionLabel(label: 'WALLET & PAYMENTS'),
                    Gap(8.h),
                    _SettingsCard(
                      children: [
                        _ChevronRow(
                          icon: Icons.credit_card_outlined,
                          label: 'Cardano wallet',
                          trailing: shortAddress.isNotEmpty ? shortAddress : null,
                          onTap: () => Get.to(
                              () => const WalletInfo(),
                              transition: Transition.rightToLeft),
                        ),
                        const _CardDivider(),
                        _ToggleRow(
                          icon: Icons.bolt_outlined,
                          label: 'Auto-pay rides',
                          subtitle: 'Skip confirmation under 5 ₳',
                          value: _autoPay,
                          onChanged: (v) => setState(() => _autoPay = v),
                        ),
                        const _CardDivider(),
                        _ChevronRow(
                          icon: Icons.receipt_long_outlined,
                          label: 'Receipt preferences',
                          onTap: () {},
                        ),
                      ],
                    ),

                    Gap(24.h),

                    // ── APP ───────────────────────────────────────────────────
                    _SectionLabel(label: 'APP'),
                    Gap(8.h),
                    _SettingsCard(
                      children: [
                        _ChevronRow(
                          icon: Icons.language_outlined,
                          label: 'Language',
                          trailing: 'English',
                          onTap: () {},
                        ),
                        const _CardDivider(),
                        _ChevronRow(
                          icon: Icons.currency_exchange_outlined,
                          label: 'Currency display',
                          trailing: 'ADA / USD',
                          onTap: () {},
                        ),
                        const _CardDivider(),
                        _ChevronRow(
                          icon: Icons.info_outline_rounded,
                          label: 'About Ryde',
                          subtitle: 'Version 1.0.2 (4)',
                          onTap: () {},
                        ),
                        const _CardDivider(),
                        _ChevronRow(
                          icon: Icons.help_outline_rounded,
                          label: 'Help center',
                          onTap: () {},
                          isLast: true,
                        ),
                      ],
                    ),

                    Gap(40.h),
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

// ── Section label ──────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppThemes.getCustomTextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        weight: FontWeight.w600,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }
}

// ── White card wrapper ─────────────────────────────────────────────────────
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(children: children),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Color(0xFFF3F4F6), height: 1),
    );
  }
}

// ── Icon helper ────────────────────────────────────────────────────────────
Widget _iconBox(IconData icon) {
  return Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: const Color(0xFFEEEAF8),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: AppColors.purple, size: 18),
  );
}

// ── Toggle row ─────────────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      child: Row(
        children: [
          _iconBox(icon),
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
                if (subtitle != null)
                  Text(
                    subtitle!,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.purple,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD1D5DB),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

// ── Chevron row ────────────────────────────────────────────────────────────
class _ChevronRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final String? trailing;
  final VoidCallback onTap;
  final bool isLast;

  const _ChevronRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            _iconBox(icon),
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
                  if (subtitle != null)
                    Text(
                      subtitle!,
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
            if (trailing != null) ...[
              Text(
                trailing!,
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  weight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}
