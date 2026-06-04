import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ridex/core/core_constants/media.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/dialog_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../shared_widgets/loader.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory>
    with SingleTickerProviderStateMixin {
  late AuthVm authVm;
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    authVm = context.read<AuthVm>();
    authVm.getUserById(authVm.currentUser!.id!);
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) return;
        setState(() => _tabIndex = _tabController.index);
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authVm = context.watch<AuthVm>();
    final rides = authVm.currentUser?.userRides ?? [];

    final myTrips =
        rides.where((r) => r.status?.toLowerCase() != 'completed').toList();
    final completed =
        rides.where((r) => r.status?.toLowerCase() == 'completed').toList();

    // Stats
    final tripCount = completed.length;
    final totalSpent = completed.fold<double>(
        0, (sum, r) => sum + (double.tryParse(r.pricePerSeat ?? '0') ?? 0));
    const double totalEarned = 0.0; // earned from scans — not in model yet

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(8.h),

                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    Label.rideHistory,
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 28,
                      weight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),

                Gap(16.h),

                // Purple stats banner
                _StatsBanner(
                  tripCount: tripCount,
                  totalSpent: totalSpent,
                  totalEarned: totalEarned,
                ),

                Gap(16.h),

                // Lavender segmented tab control
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEAF8),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      labelStyle: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        weight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                      unselectedLabelStyle: AppThemes.getCustomTextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        weight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: const Color(0xFF9CA3AF),
                      tabs: const [
                        Tab(text: 'My trips'),
                        Tab(text: 'Completed'),
                      ],
                    ),
                  ),
                ),

                Gap(16.h),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _TripList(
                        rides: myTrips,
                        isCompleted: false,
                      ),
                      _TripList(
                        rides: completed,
                        isCompleted: true,
                      ),
                    ],
                  ),
                ),

                Gap(85.h),
              ],
            ),
          ),

          if (authVm.isLoading)
            const Loader(loaderText: 'Fetching trips…'),
        ],
      ),
    );
  }
}

// ── Stats banner ──────────────────────────────────────────────────────────────
class _StatsBanner extends StatelessWidget {
  final int tripCount;
  final double totalSpent;
  final double totalEarned;

  const _StatsBanner({
    required this.tripCount,
    required this.totalSpent,
    required this.totalEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5500BF), Color(0xFF7C3AED)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THIS MONTH',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      weight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$tripCount ${tripCount == 1 ? 'trip' : 'trips'}',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${totalSpent.toStringAsFixed(1)} ₳ spent · ${totalEarned.toStringAsFixed(2)} ₳ earned',
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      weight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Media.car,
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.srcIn),
                  width: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Trip list with section headers ───────────────────────────────────────────
class _TripList extends StatelessWidget {
  final List<RideModel> rides;
  final bool isCompleted;

  const _TripList({required this.rides, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    if (rides.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Media.empty, height: 200, width: 200),
            Gap(16.h),
            Text(
              Label.noTrips,
              style: AppThemes.getCustomTextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                weight: FontWeight.w500,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    }

    // Group into "Today" and "Earlier this week"
    final now = DateTime.now();
    final today = <RideModel>[];
    final earlier = <RideModel>[];

    for (final ride in rides) {
      final dt = ride.departureTime ?? ride.createdAt;
      if (dt != null &&
          dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day) {
        today.add(ride);
      } else {
        earlier.add(ride);
      }
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        if (today.isNotEmpty) ...[
          _SectionHeader(label: 'TODAY'),
          Gap(8.h),
          ...today.map((r) => _TripCard(ride: r, isCompleted: isCompleted)),
          Gap(16.h),
        ],
        if (earlier.isNotEmpty) ...[
          _SectionHeader(label: 'EARLIER THIS WEEK'),
          Gap(8.h),
          ...earlier.map((r) => _TripCard(ride: r, isCompleted: isCompleted)),
        ],
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

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

// ── Trip card ─────────────────────────────────────────────────────────────────
class _TripCard extends StatelessWidget {
  final RideModel ride;
  final bool isCompleted;

  const _TripCard({required this.ride, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final driverName = ride.driver?.user?.fullName ?? 'Driver';
    final initial =
        driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D';
    final vehicleType = ride.driver?.vehicleType ?? '';
    final price = double.tryParse(ride.pricePerSeat ?? '0') ?? 0.0;
    final pickup = (ride.pickUp is DropOff)
        ? (ride.pickUp as DropOff).name ?? ''
        : '';
    final dropoff = (ride.dropOff is DropOff)
        ? (ride.dropOff as DropOff).name ?? ''
        : '';
    final status = ride.status ?? '';

    // Day label
    final dt = ride.departureTime ?? ride.createdAt;
    String dayLabel = '';
    if (dt != null) {
      final now = DateTime.now();
      final diff = now.difference(dt).inDays;
      if (diff == 0) {
        dayLabel = 'Today';
      } else if (diff == 1) {
        dayLabel = 'Yesterday';
      } else {
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        dayLabel = days[(dt.weekday - 1) % 7];
      }
    }

    final isCancelled = status.toLowerCase() == 'cancelled';
    final chipColor = isCancelled
        ? const Color(0xFFFEF3C7)
        : const Color(0xFFDCFCE7);
    final chipTextColor = isCancelled
        ? const Color(0xFFD97706)
        : const Color(0xFF16A34A);
    final chipLabel = isCancelled ? 'cancelled' : 'completed';

    return GestureDetector(
      onTap: !isCompleted
          ? () {
              locator<DialogService>().showAlertDialog(
                context: context,
                title: 'Cancel Ride',
                message: 'Do you wish to cancel this ride?',
                showCancelBtn: true,
                type: AlertDialogType.error,
                onOkayBtnTap: () async {
                  Navigator.pop(context);
                  final rideVm = context.read<RideProvider>();
                  final authVmInner = context.read<AuthVm>();
                  await rideVm.cancelBooking(
                    ride.uuid!,
                    authVmInner.currentUser!.id!,
                    onSuccess: () {
                      authVmInner.getUserById(authVmInner.currentUser!.id!);
                    },
                  );
                },
                onCancelBtnTap: () => Navigator.pop(context),
              );
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Driver initial avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purple,
                  ),
                  child: Center(
                    child: Text(
                      initial,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (vehicleType.isNotEmpty)
                        Text(
                          vehicleType,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${price.toStringAsFixed(2)} ₳',
                      style: AppThemes.getCustomTextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        weight: FontWeight.w700,
                        color: AppColors.purple,
                      ),
                    ),
                    Text(
                      dayLabel,
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

            const SizedBox(height: 12),

            // Route row
            Row(
              children: [
                Column(
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
                      color: const Color(0xFFE5E7EB),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
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
                      Text(
                        pickup.isNotEmpty ? pickup : 'Pickup',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          weight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dropoff.isNotEmpty ? dropoff : 'Dropoff',
                        style: AppThemes.getCustomTextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          weight: FontWeight.w500,
                          color: AppColors.primaryColor,
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
                    color: chipColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    chipLabel,
                    style: AppThemes.getCustomTextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      weight: FontWeight.w600,
                      color: chipTextColor,
                    ),
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
