import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridex/services/location_service.dart';
import 'package:ridex/ui/screens/home/bottom_card_widget.dart';
import 'package:ridex/ui/shared_widgets/loader.dart';
import 'package:ridex/ui/shared_widgets/top_container.dart';

import '../../../app/theme.dart';
import '../../../data/locator.dart';
import '../../../services/dialog_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final location = locator<LocationService>();
  final dialog = locator<DialogService>();
  final TextEditingController locationController = TextEditingController();
  GoogleMapController? mapController;

  //call the app to get the location

  //TODO: load drivers markers for visualization

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
            child: HomeTopContainer()
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 88.h,
            child: BottomCardWidget(
              onBtnTap: () {
                if (locationController.text.isEmpty) {
                  dialog.showSnackBar("No destination Input", "Please enter a valid destination/stop");
                  return;
                }
              },
              locationController: locationController,
            ),
          ),
        ],
      ),
    );
  }
}
