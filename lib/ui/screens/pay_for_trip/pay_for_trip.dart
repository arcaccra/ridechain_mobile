import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/trip_firebase_service.dart';
import 'package:ridex/ui/screens/pay_for_trip/payment_success_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../data/locator.dart';

class PayForTrip extends StatelessWidget {
  const PayForTrip({super.key});

  @override
  Widget build(BuildContext context) {
    final rideVm = context.watch<RideProvider>();
    final authVm = context.watch<AuthVm>();

    final ride = rideVm.selectedRide;
    final price = double.tryParse(ride?.pricePerSeat ?? '0') ?? 0.0;
    final networkFee = price * 0.068;
    final total = price + networkFee;

    final driver = ride?.driver;
    final driverName = driver?.user?.fullName ?? 'Driver';
    final driverInitial =
        driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D';
    final pickup = ride?.pickUp?.name ?? '';
    final dropoff = ride?.dropOff?.name ?? '';

    final wallet = authVm.userWallet;
    final balance = wallet?.balance?.ada;
    final address = wallet?.address ?? authVm.walletAddress ?? '';
    final shortAddress = address.length > 20
        ? '${address.substring(0, 10)}...${address.substring(address.length - 8)}'
        : address;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: EdgeInsets.only(top: 8.h, left: 8.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  color: AppColors.primaryColor,
                  onPressed: () => Get.back(),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Gap(8.h),

                    // TRIP TOTAL label
                    Text(
                      'TRIP TOTAL',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        weight: FontWeight.w600,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),

                    Gap(6.h),

                    // Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          total.toStringAsFixed(2),
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 52,
                            weight: FontWeight.w800,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '₳',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 48,
                            weight: FontWeight.w800,
                            color: AppColors.purple,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      '≈ \$${(total * 0.184).toStringAsFixed(2)} USD',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        weight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),

                    Gap(24.h),

                    // Wallet card (dark)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PAY FROM',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  weight: FontWeight.w500,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.purple,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cardano Wallet',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              weight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ADA',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  weight: FontWeight.w600,
                                  color: AppColors.purple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Available balance',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              weight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
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
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (address.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => Clipboard.setData(
                                        ClipboardData(text: address)),
                                    child: const Icon(
                                        Icons.copy_rounded,
                                        color: Color(0xFF6B7280),
                                        size: 16),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(16.h),

                    // Trip summary card (white)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Driver + route header
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.purple,
                                ),
                                child: Center(
                                  child: Text(
                                    driverInitial,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      driverName,
                                      style: AppThemes.getCustomTextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        weight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    Text(
                                      '${pickup.isNotEmpty ? pickup : 'Pickup'} → ${dropoff.isNotEmpty ? dropoff : 'Dropoff'}',
                                      style: AppThemes.getCustomTextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        weight: FontWeight.w400,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
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
                                      'Trip done',
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

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Divider(
                                color: Color(0xFFF3F4F6), height: 1),
                          ),

                          // Breakdown rows
                          _BreakdownRow(
                            label: '1 seat × ${price.toStringAsFixed(1)} ₳',
                            value: '${price.toStringAsFixed(2)} ₳',
                          ),
                          const SizedBox(height: 8),
                          _BreakdownRow(
                            label: 'Cardano network fee',
                            value: '${networkFee.toStringAsFixed(2)} ₳',
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(
                                color: Color(0xFFF3F4F6), height: 1),
                          ),
                          _BreakdownRow(
                            label: 'Total',
                            value: '${total.toStringAsFixed(2)} ₳',
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),
                  ],
                ),
              ),
            ),

            // Bottom section
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final paymentId = const Uuid().v4();
                        await locator<TripFirebaseService>().completePayment(
                          paymentId: paymentId,
                          username: authVm.currentUser?.fullName ?? '',
                          tripId: ride?.uuid ?? '',
                          userId:
                              authVm.currentUser?.id.toString() ?? '',
                          amount: price,
                        );
                        Get.to(() => const PaymentSuccessScreen());
                      },
                      icon: const Icon(Icons.shield_outlined,
                          color: Colors.white, size: 18),
                      label: Text(
                        'Confirm payment · ${total.toStringAsFixed(2)} ₳',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding:
                            const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Settled on Cardano · 1 ADA = 1,000,000 lovelace',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      weight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
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

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _BreakdownRow(
      {required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppThemes.getCustomTextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            weight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold
                ? AppColors.primaryColor
                : const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: AppThemes.getCustomTextStyle(
            fontFamily: 'Outfit',
            fontSize: bold ? 15 : 13,
            weight: bold ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
