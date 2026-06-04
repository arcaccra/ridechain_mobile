import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';
import '../../../../core/core_constants/media.dart';
import '../../../../data/models/ride_model.dart';
import '../widgets/history_widget.dart';

class CompletedTrips extends StatelessWidget {
  final List<RideModel> rides;
  const CompletedTrips({super.key, required this.rides});

  @override
  Widget build(BuildContext context) {
    return rides.isEmpty
        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Image.asset(Media.empty, height: 250, width: 250), Gap(20.h), Text(Label.noTrips, style: AppThemes.getCustomTextStyle(fontSize: 18, fontFamily: "Outfit", weight: FontWeight.w500, color: AppColors.black))]))
        : ListView.builder(
          itemCount: rides.length,
          itemBuilder: (context, index) {
            final ride = rides[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              // margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
              child: HistoryWidget(ride: ride, isCompleted: true),
            ).animate(effects: [SlideEffect(begin: Offset(0, 0.3), end: Offset(0, 0), duration: Duration(seconds: 1), curve: Curves.easeOutBack), FadeEffect(begin: 0.0, end: 1.0, duration: 500.ms, delay: 200.ms)]);
          },
        );
  }
}
