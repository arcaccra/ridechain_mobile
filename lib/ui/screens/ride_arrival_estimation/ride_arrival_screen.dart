import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridex/ui/screens/ride_arrival_estimation/widgets/ride_arrival_bottom_widget.dart';

import '../../../data/locator.dart';
import '../../../services/dialog_service.dart';
import '../../../services/location_service.dart';
import '../../shared_widgets/loader.dart';
import '../../shared_widgets/top_container.dart';


class RideArrivalScreen extends StatefulWidget {
  const RideArrivalScreen({super.key});

  @override
  State<RideArrivalScreen> createState() => _RideArrivalScreenState();
}

class _RideArrivalScreenState extends State<RideArrivalScreen> {

  final location = locator<LocationService>();
  final dialog = locator<DialogService>();
  GoogleMapController? mapController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<Position>(
            stream: location.stream,
            builder: (context, snapshot) {
              Position? userLocation = snapshot.data;
              if (snapshot.hasError) {
                dialog.showSnackBar("Caution..", "User location cannot be fetched at this time. Please try again...");
                return SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: GoogleMap(onMapCreated: (controller) => mapController = controller, myLocationEnabled: true, myLocationButtonEnabled: false, mapType: MapType.normal, initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0))),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader(loaderText: "Getting location");
              }
              return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GoogleMap(onMapCreated: (controller) => mapController = controller, myLocationEnabled: true, myLocationButtonEnabled: false, mapType: MapType.normal, initialCameraPosition: CameraPosition(zoom: 18, target: LatLng(userLocation!.latitude, userLocation.longitude))),
              );
            },
          ),
          Positioned(
              left: 0.25.sw,
              right: 0.25.sw,
              top: kToolbarHeight + 15.h,
              child: HomeTopContainer(title: "Estimated Arrival time: 10:30",)
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 88.h,
            child: RideArrivalBottomWidget()
          ),
        ],
      ),
    );
  }
}
