import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/payment_provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';
import 'package:ridex/ui/screens/rate_driver/rate_driver_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String? txHash;
  const PaymentSuccessScreen({super.key, this.txHash});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  Timer? _timer;

  String get _txHash => widget.txHash ?? context.read<PaymentProvider>().txHash ?? '';

  String get _shortHash {
    final h = _txHash;
    if (h.length <= 16) return h;
    return '${h.substring(0, 8)}…${h.substring(h.length - 8)}';
  }

  Future<void> _openCardanoScan() async {
    if (_txHash.isEmpty) return;
    final uri = Uri.parse('https://cardanoscan.io/transaction/$_txHash');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideVm = context.watch<RideProvider>();

    final ride = rideVm.selectedRide;
    final price = double.tryParse(ride?.pricePerSeat ?? '0') ?? 0.0;
    final networkFee = price * 0.068;
    final total = price + networkFee;

    final driver = ride?.driver;
    final driverName = driver?.user?.fullName ?? 'Driver';
    final firstName = driverName.split(' ').first;
    final vehicleType = driver?.vehicleType ?? '';

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Gap(48.h),

                    // Green check circle
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF16A34A),
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 40),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.6, 0.6),
                          end: const Offset(1, 1),
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fade(begin: 0, end: 1, duration: 400.ms),

                    Gap(24.h),

                    Text(
                      'Payment sent',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 28,
                        weight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                        .animate(delay: 100.ms)
                        .fade(begin: 0, end: 1, duration: 400.ms),

                    Gap(6.h),

                    Text(
                      '${total.toStringAsFixed(2)} ₳ paid to $firstName.',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    )
                        .animate(delay: 150.ms)
                        .fade(begin: 0, end: 1, duration: 400.ms),

                    Gap(28.h),

                    // Receipt card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Receipt',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  weight: FontWeight.w600,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF14532D),
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
                                    const SizedBox(width: 5),
                                    Text(
                                      'Confirmed',
                                      style: AppThemes.getCustomTextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        weight: FontWeight.w600,
                                        color: Color(0xFF16A34A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _ReceiptRow(
                              label: 'Amount',
                              value:
                                  '${total.toStringAsFixed(2)} ₳'),
                          _ReceiptRow(
                              label: 'Driver',
                              value: firstName.isNotEmpty
                                  ? '$firstName D.'
                                  : '—'),
                          _ReceiptRow(
                              label: 'Trip',
                              value: vehicleType.isNotEmpty
                                  ? vehicleType
                                  : '—'),
                          _ReceiptRow(
                              label: 'Date',
                              value:
                                  'Today · ${TimeOfDay.now().format(context)}'),
                          _ReceiptRow(
                              label: 'Tx hash',
                              value: _shortHash.isNotEmpty ? _shortHash : '—',
                              valueColor: AppColors.purple,
                              onValueTap: _txHash.isNotEmpty ? _openCardanoScan : null,
                              onValueLongPress: _txHash.isNotEmpty
                                  ? () => Clipboard.setData(ClipboardData(text: _txHash))
                                  : null),
                        ],
                      ),
                    )
                        .animate(delay: 200.ms)
                        .fade(begin: 0, end: 1, duration: 400.ms),

                    Gap(14.h),

                    // Scan QR bonus banner
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.purple.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.bolt_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan your ride QR for 0.05 ₳',
                                  style: AppThemes.getCustomTextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    weight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Verified trip bonus',
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
                              color: Color(0xFF6B7280), size: 20),
                        ],
                      ),
                    )
                        .animate(delay: 250.ms)
                        .fade(begin: 0, end: 1, duration: 400.ms),

                    Gap(24.h),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const RateDriverScreen());
                      },
                      icon: const Icon(Icons.star_rounded,
                          color: Color(0xFFF59E0B), size: 20),
                      label: Text(
                        'Rate your driver',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          weight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      rideVm.resetRideState();
                      Get.offAll(() => const AppNavigationScreen(),
                          transition: Transition.leftToRight);
                    },
                    child: Text(
                      'Back home',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        weight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  Gap(8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onValueTap;
  final VoidCallback? onValueLongPress;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.onValueTap,
    this.onValueLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppThemes.getCustomTextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              weight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
          ),
          GestureDetector(
            onTap: onValueTap,
            onLongPress: onValueLongPress,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    weight: FontWeight.w600,
                    color: valueColor ?? Colors.white,
                  ),
                ),
                if (onValueTap != null) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.open_in_new_rounded,
                      size: 13, color: valueColor ?? Colors.white),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
