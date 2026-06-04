import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/data/models/ride_model.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/media.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmRide extends StatefulWidget {
  final RideModel? ride;
  final VoidCallback? onCancelTap;
  final void Function(int seats)? onConfirmTap;

  const ConfirmRide({
    super.key,
    this.ride,
    this.onCancelTap,
    this.onConfirmTap,
  });

  @override
  State<ConfirmRide> createState() => _ConfirmRideState();
}

class _ConfirmRideState extends State<ConfirmRide> {
  int _seats = 1;

  double get _pricePerSeat =>
      double.tryParse(widget.ride?.pricePerSeat ?? '0') ?? 0.0;
  double get _networkFee => _pricePerSeat * _seats * 0.068; // ~6.8% fee
  double get _total => (_pricePerSeat * _seats) + _networkFee;
  int get _maxSeats => widget.ride?.seatsAvailable ?? 1;

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    final driver = ride?.driver;
    final driverName = driver?.user?.fullName ?? 'Driver';
    final initial = driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D';
    final vehicleType = driver?.vehicleType ?? '';
    final vehicleColor = driver?.vehicleColor ?? '';
    final plate = driver?.vehiclePlateNumber ?? '';
    final pickup = ride?.pickUp?.name ?? 'Pickup';
    final dropoff = ride?.dropOff?.name ?? 'Destination';

    return Container(
      height: 0.95.sh,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 12.h, 16, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map preview area
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      children: [
                        Container(
                          height: 160.h,
                          color: AppColors.darkBackground,
                          child: Center(
                            child: Icon(
                              Icons.map_outlined,
                              color: Colors.white.withValues(alpha: 0.1),
                              size: 80,
                            ),
                          ),
                        ),
                        // ETA chip
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    color: Colors.white, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  '28 min · 14.2 km',
                                  style: AppThemes.getCustomTextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    weight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(14.h),

                  // Driver card
                  _Card(
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.purple,
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driverName,
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 16,
                                  weight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Color(0xFFF59E0B), size: 14),
                                  const SizedBox(width: 3),
                                  Text(
                                    '4.9',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      weight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    ' · 312 trips',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      weight: FontWeight.w400,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Phone button
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const Icon(Icons.phone_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  Gap(10.h),

                  // Vehicle card
                  _Card(
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEAF8),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Media.car,
                              width: 30,
                              height: 30,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.purple, BlendMode.srcIn),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VEHICLE',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  weight: FontWeight.w500,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '$vehicleType · $vehicleColor',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (plate.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              plate,
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Gap(10.h),

                  // Route + seats card
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pickup
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.purple,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 28,
                                  color: const Color(0xFFD1D5DB),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pickup · 8:24 AM',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      weight: FontWeight.w400,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  Text(
                                    pickup,
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      weight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Dropoff
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Drop-off · 8:52 AM',
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      weight: FontWeight.w400,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  Text(
                                    dropoff,
                                    style: AppThemes.getCustomTextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      weight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFF3F4F6), height: 1),
                        const SizedBox(height: 14),

                        // Seats stepper
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                color: AppColors.purple, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Seats',
                              style: AppThemes.getCustomTextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                weight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const Spacer(),
                            // Decrease
                            GestureDetector(
                              onTap: _seats > 1
                                  ? () => setState(() => _seats--)
                                  : null,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _seats > 1
                                      ? const Color(0xFFEEEAF8)
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: _seats > 1
                                      ? AppColors.primaryColor
                                      : const Color(0xFFD1D5DB),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                '$_seats',
                                style: AppThemes.getCustomTextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 18,
                                  weight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            // Increase
                            GestureDetector(
                              onTap: _seats < _maxSeats
                                  ? () => setState(() => _seats++)
                                  : null,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _seats < _maxSeats
                                      ? AppColors.purple
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 16,
                                  color: _seats < _maxSeats
                                      ? Colors.white
                                      : const Color(0xFFD1D5DB),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Gap(10.h),

                  // Fare breakdown (dark card)
                  Container(
                    padding: EdgeInsets.all(18.r),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        _FareLine(
                          label:
                              '$_seats seat${_seats > 1 ? 's' : ''} × ${_pricePerSeat.toStringAsFixed(1)} ₳',
                          value:
                              '${(_pricePerSeat * _seats).toStringAsFixed(2)} ₳',
                          labelColor: const Color(0xFF9CA3AF),
                          valueColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        _FareLine(
                          label: 'Network fee',
                          value: '${_networkFee.toStringAsFixed(2)} ₳',
                          labelColor: const Color(0xFF9CA3AF),
                          valueColor: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                              color: Color(0xFF2D2D3F), height: 1),
                        ),
                        _FareLine(
                          label: 'Total',
                          value: '${_total.toStringAsFixed(2)} ₳',
                          labelColor: Colors.white,
                          valueColor: AppColors.purple,
                          valueFontSize: 22,
                          valueBold: true,
                        ),
                      ],
                    ),
                  ),

                  Gap(20.h),
                ],
              ),
            ),
          ),

          // Book ride button
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24.h),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onConfirmTap != null
                    ? () => widget.onConfirmTap!(_seats)
                    : null,
                icon: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 20),
                label: Text(
                  'Book ride',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FareLine extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final double valueFontSize;
  final bool valueBold;

  const _FareLine({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.valueFontSize = 14,
    this.valueBold = false,
  });

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
            weight: FontWeight.w400,
            color: labelColor,
          ),
        ),
        Text(
          value,
          style: AppThemes.getCustomTextStyle(
            fontFamily: 'Outfit',
            fontSize: valueFontSize,
            weight: valueBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
