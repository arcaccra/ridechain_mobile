import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:provider/provider.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/location_service.dart';
import 'package:ridex/ui/shared_widgets/pickup_destination_widget.dart';

import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../shared_widgets/available_car_card.dart';
import '../../shared_widgets/default_button.dart';

class ShowAvailableCarsWidget extends StatelessWidget {
  const ShowAvailableCarsWidget({super.key, this.destination, required this.onBtnTap, required this.locationStream});
  final String? destination;
  final Stream<Position> locationStream;
  final VoidCallback onBtnTap;

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RideProvider>(context);
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16,),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.11),
              spreadRadius: 0,
              blurRadius: 13.4,
              offset: Offset(0, 3.27),)
          ]
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: PickupDestinationWidget(title: Label.pickup, data: "My Location",)),
                  Gap(12.w),
                  Expanded(child: PickupDestinationWidget(title: Label.destination, data: destination ?? "",)),
                ],
              ),
            ),
          ),
          Gap(16.h),
          StreamBuilder<Position>(
            stream: locationStream,
            builder: (context, snapshot) {
              Position? userPosition;
              if (!snapshot.hasData){
                return SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 0.4,
                  ),
                );
              }
              userPosition = snapshot.data!;
              return SizedBox(
                height: 160.h,
                width: 1.sw,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ridesProvider.rides.length,
                  itemBuilder: (context, index) {
                    final ride = ridesProvider.rides[index];
                    return GestureDetector(
                      onTap: (){
                        ridesProvider.setSelectedRide(ride);
                      },
                      child: AvailableCarCard(
                        isSelected: ridesProvider.selectedRideId == ride.uuid,
                        amount: double.parse(ride.pricePerSeat.toString()),
                        minutes: locator<LocationService>().calculateTime(ride.pickUp!.latitude!, ride.pickUp!.longitude!, userPosition!.latitude, userPosition.longitude),
                        rating: 4.5,
                      ),
                    );
                  }
              )
              );
            }
          ),
          Gap(24.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: DefaultButton(
              isNull: ridesProvider.selectedRideId.isEmpty,
              onBtnTap: onBtnTap,
              btnText: Label.bookNow,
              isIconPresent: false,
              btnColor: AppColors.primaryColor,
              btnTextColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
