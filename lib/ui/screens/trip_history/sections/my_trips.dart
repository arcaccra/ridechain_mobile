import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/dialog_service.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';
import '../../../../core/core_constants/media.dart';
import '../../../../data/models/ride_model.dart';
import '../../../../providers/auth_provider.dart';
import '../widgets/history_widget.dart';

class MyTrips extends StatelessWidget {
  final List<RideModel> rides;
  const MyTrips({super.key, required this.rides});

  @override
  Widget build(BuildContext context) {
    final rideVm = Provider.of<RideProvider>(context);
    final authVm = Provider.of<AuthVm>(context);
    return rides.isEmpty
        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Image.asset(Media.empty, height: 250, width: 250), Gap(20.h), Text(Label.noTrips, style: AppThemes.getCustomTextStyle(fontSize: 18, fontFamily: "Outfit", weight: FontWeight.w500, color: AppColors.black))]))
        : ListView.builder(
          itemCount: rides.length,
          itemBuilder: (context, index) {
            final ride = rides[index];
            return GestureDetector(
              onTap: (){
                locator<DialogService>().showAlertDialog(
                    context: context,
                    title: "Cancel Ride",
                    message: "Do you wish to cancel ride?",
                    showCancelBtn: true,
                    onOkayBtnTap: () async {
                      Navigator.pop(context);
                      await rideVm.cancelBooking(ride.uuid!, authVm.currentUser!.id!, onSuccess: (){
                        authVm.getUserById(authVm.currentUser!.id!);
                      });
                    },
                    onCancelBtnTap: (){
                      Navigator.pop(context);
                    },
                  type: AlertDialogType.error
                    );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                //margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
                child: HistoryWidget(ride: ride),
              ).animate(effects: [SlideEffect(begin: Offset(0, 0.3), end: Offset(0, 0), duration: Duration(seconds: 1), curve: Curves.easeOutBack), FadeEffect(begin: 0.0, end: 1.0, duration: 500.ms, delay: 200.ms)]),
            );
          },
        );
  }
}
