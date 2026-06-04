import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ridex/app/theme.dart';
import 'package:ridex/core/utility.dart';
import 'package:ridex/data/models/ride_model.dart';

import '../../core/core_constants/colors.dart';
import '../../core/core_constants/media.dart';
import 'package:flutter_svg/svg.dart';

class DriverCarDetailWidget extends StatelessWidget {
  final RideModel? ride;
  const DriverCarDetailWidget({super.key, this.ride});

  @override
  Widget build(BuildContext context) {
    final driver = ride?.driver;
    final driverName = driver?.user?.fullName ?? 'Driver';
    final firstName = driverName.split(' ').first;
    final initial = driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D';
    final vehicleType = driver?.vehicleType ?? '';
    final vehicleColor = driver?.vehicleColor ?? '';
    final plate = driver?.vehiclePlateNumber ?? '';
    final pickup = ride?.pickUp?.name ?? '';
    final dropoff = ride?.dropOff?.name ?? '';
    final price = double.tryParse(ride?.pricePerSeat ?? '0') ?? 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEAF8),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.purple.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Awaiting driver response',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        weight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      '$firstName is reviewing your request…',
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
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Driver row
        Row(
          children: [
            // Avatar
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      weight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFF59E0B), size: 13),
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
            // Phone button
            GestureDetector(
              onTap: () {
                final phone = driver?.user?.phoneNumber;
                if (phone != null) Utils.makePhoneCall(phone);
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(Icons.phone_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Plate row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEAF8),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Media.car,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                    AppColors.purple, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              Text(
                'Look for plate',
                style: AppThemes.getCustomTextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  weight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryColor, width: 1.5),
                ),
                child: Text(
                  plate.isNotEmpty ? plate : '— —',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    weight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Route + fare row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dots + connector
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
                  height: 18,
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
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'From · ',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            weight: FontWeight.w400,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        TextSpan(
                          text: pickup.isNotEmpty ? pickup : 'Current location',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            weight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'To · ',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            weight: FontWeight.w400,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        TextSpan(
                          text: dropoff.isNotEmpty ? dropoff : 'Destination',
                          style: AppThemes.getCustomTextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            weight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Fare',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    weight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  '${price.toStringAsFixed(1)} ₳',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    weight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
