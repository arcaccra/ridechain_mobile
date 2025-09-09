import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/ui/screens/pay_for_trip/widgets/payment_success_details_widget.dart';
import 'package:ridex/ui/screens/rate_driver/rate_driver_screen.dart';
import 'package:ridex/ui/shared_widgets/default_button.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../data/locator.dart';
import '../../../services/dialog_service.dart';


class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  RideProvider? rideProvider;
  TextEditingController reviewController = TextEditingController();

  Timer? _timer;

  @override
  void initState() {
    rideProvider = context.read<RideProvider>();
    super.initState();
   _showRatingScreen();
  }

  _showRatingScreen() async {
    _timer = Timer(const Duration(seconds: 3), () async {
      locator<DialogService>().showCustomModal(
          context: context,
          isDismissible: false,
          customModal: RateDriverScreen()
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Label.paymentSuccessful, style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 24, lineHeight: 1.33), textAlign: TextAlign.center)
                .animate(delay: 100.ms)
                .slide(
              begin: const Offset(0, -0.3),
              end: const Offset(0, 0), // End at center
              duration: 600.ms,
              curve: Curves.easeOutBack,
            )
                .fade(begin: 0, end: 1, duration: 600.ms),
            Gap(4.h),
            Text("${Label.paymentSuccessfulMsg} ADA ${ride.selectedRide?.pricePerSeat}", style: AppThemes.getCustomTextStyle(fontFamily: "Beau Sans", weight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 14, lineHeight: 1.33), textAlign: TextAlign.center)
                .animate(delay: 100.ms)
                .slide(
              begin: const Offset(0, -0.3),
              end: const Offset(0, 0), // End at center
              duration: 600.ms,
              curve: Curves.easeOutBack,
            )
                .fade(begin: 0, end: 1, duration: 600.ms),
            Gap(30.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PaymentSuccessDetailsWidget(ride: ride.selectedRide!,)
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.feed_outlined, color: AppColors.yellow, size: 14),
                        Gap(4.w),
                        Text(Label.downloadReceipt, style: AppThemes.getCustomTextStyle(color: AppColors.yellow, fontSize: 11, weight: FontWeight.w500, fontFamily: "Outfit")),
                      ],
                    ),
                  )

                ],
              ),
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }
}
