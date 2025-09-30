import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/ui/shared_widgets/accepted_trip_detail_widget.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';


class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(kToolbarHeight + 10.h),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(Label.rideHistory, style: AppThemes.getCustomTextStyle(color: AppColors.black, fontSize: 24, weight: FontWeight.w700, fontFamily: "Outfit")),
          ),
          Gap(20.h),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(Label.thisWeek, style: AppThemes.getCustomTextStyle(color: AppColors.greyAd, fontSize: 16, weight: FontWeight.w500, fontFamily: "Outfit")),
          ),
          Expanded(child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),),
                  child: AcceptedTripDetailWidget(),
                ).animate(effects: [SlideEffect(
                  begin: Offset(0, 0.3),
                  end: Offset(0, 0),
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOutBack,
                ),
                  FadeEffect(
                    begin: 0.0,
                    end: 1.0,
                    duration: 500.ms,
                    delay: 200.ms,
                  ),]);
              })),
          Gap(85.h),
        ],
      ),
    );
  }
}
