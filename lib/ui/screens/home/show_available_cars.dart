import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:provider/provider.dart';
import 'package:ridex/providers/rides_provider.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../data/models/ride_model.dart';

class ShowAvailableCarsWidget extends StatelessWidget {
  const ShowAvailableCarsWidget({
    super.key,
    this.destination,
    required this.onBtnTap,
    required this.onCancelTap,
    required this.locationStream,
  });

  final String? destination;
  final Stream<Position> locationStream;
  final VoidCallback onBtnTap;
  final VoidCallback onCancelTap;

  @override
  Widget build(BuildContext context) {
    final ridesProvider = context.watch<RideProvider>();
    final rides = ridesProvider.rides;
    final count = rides.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route summary pill
          Container(
            margin: EdgeInsets.fromLTRB(16, 16.h, 16, 0),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                // Route dots
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.purple,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 14,
                      color: const Color(0xFFD1D5DB),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current location',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          weight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        destination ?? 'Destination',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          weight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Distance badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Distance',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        weight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    Text(
                      '14.2 km',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        weight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Header row
          Padding(
            padding: EdgeInsets.fromLTRB(16, 14.h, 16, 10.h),
            child: Row(
              children: [
                Text(
                  '$count ride${count == 1 ? '' : 's'} available',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    weight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
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
                        'Live',
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
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    'Sort: Soonest',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      weight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ride cards list
          SizedBox(
            height: 280.h,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                final isSelected =
                    ridesProvider.selectedRideId == ride.uuid;
                return _RideCard(
                  ride: ride,
                  isSelected: isSelected,
                  onTap: () => ridesProvider.setSelectedRide(ride),
                );
              },
            ),
          ),

          // Confirm button
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8.h, 16, 6.h),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ridesProvider.selectedRideId.isEmpty
                    ? null
                    : onBtnTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  disabledBackgroundColor:
                      AppColors.purple.withValues(alpha: 0.4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm ride',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Cancel link
          Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Center(
              child: GestureDetector(
                onTap: onCancelTap,
                child: Text(
                  'Cancel',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    weight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final RideModel ride;
  final bool isSelected;
  final VoidCallback onTap;

  const _RideCard({
    required this.ride,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final driver = ride.driver;
    final driverName = driver?.user?.fullName ?? 'Driver';
    final firstName = driverName.split(' ').first;
    final initial = driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D';
    final vehicleType = driver?.vehicleType ?? 'Vehicle';
    final vehicleColor = driver?.vehicleColor ?? '';
    final price = double.tryParse(ride.pricePerSeat ?? '0') ?? 0.0;
    final seats = ride.seatsAvailable ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.purple : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + name/info + price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver avatar
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.purple,
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF16A34A),
                          border: Border.all(
                              color: AppColors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Driver name + vehicle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$firstName D.',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              weight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '· 312 trips',
                            style: AppThemes.getCustomTextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              weight: FontWeight.w400,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
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
                              weight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            ' · $vehicleType'
                            '${vehicleColor.isNotEmpty ? ' · $vehicleColor' : ''}',
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
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${price.toStringAsFixed(1)}₳',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        weight: FontWeight.w700,
                        color: AppColors.purple,
                      ),
                    ),
                    Text(
                      'per seat',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        weight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(color: Color(0xFFF3F4F6), height: 1),
            const SizedBox(height: 10),

            // Bottom row: leave time + seats
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    color: Color(0xFF9CA3AF), size: 14),
                const SizedBox(width: 4),
                Text(
                  'Leaves ',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    weight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                Text(
                  '8:24 AM',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    weight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '28 min',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    weight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.person_outline_rounded,
                    color: Color(0xFF9CA3AF), size: 14),
                const SizedBox(width: 4),
                Text(
                  '$seats seat${seats == 1 ? '' : 's'}',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    weight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
