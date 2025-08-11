import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/services/location_service.dart';
import 'package:ridex/ui/screens/home/bottom_card_widget.dart';
import 'package:ridex/ui/screens/home/show_available_cars.dart';
import 'package:ridex/ui/screens/home/widget/progressive_map_widget.dart';
import 'package:ridex/ui/shared_widgets/driver_en_route_card.dart';
import 'package:ridex/ui/shared_widgets/loader.dart';
import 'package:ridex/ui/shared_widgets/top_container.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
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
  late AuthVm authVm;

  //call the app to get the location

  //TODO: load drivers markers for visualization

  //show searching available cars
  bool isAvailableCars = false;
  bool isRiderComing = false;
  String? destination;

  bool onFirstLocationTry = true;

  // Your location stream (replace with your actual implementation)
  late Stream<Position> locationStream;

  @override
  void initState() {
    //TODO: Activate fetch the driver details and show them on the map
    authVm = context.read<AuthVm>();
    super.initState();
    authVm.getAllDrivers();
    // Initialize your location stream here
    locationStream = _createLocationStream();
  }

  Stream<Position> _createLocationStream() {
    return Stream.periodic(const Duration(seconds: 2), (index) {
      // Replace with your actual location service
      return Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
    }).asyncMap((future) => future);
  }

  @override
  Widget build(BuildContext context) {
    authVm = context.watch<AuthVm>();
    return Scaffold(
      body: Stack(
        children: [
          // StreamBuilder<Position>(
          //   stream: location.stream,
          //   builder: (context, snapshot) {
          //     Position? userLocation = snapshot.data;
          //     if (snapshot.hasError) {
          //       dialog.showSnackBar("Caution..", "User location cannot be fetched at this time. Please try again...");
          //       return SizedBox(
          //         height: double.infinity,
          //         width: double.infinity,
          //         child: GoogleMap(onMapCreated: (controller) => mapController = controller, myLocationEnabled: true, myLocationButtonEnabled: false, mapType: MapType.normal, initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0))),
          //       );
          //     }
          //
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Loader(loaderText: "Getting location");
          //     }
          //
          //
          //     onFirstLocationTry = false;
          //
          //     return SizedBox(
          //       height: double.infinity,
          //       width: double.infinity,
          //       child: GoogleMap(onMapCreated: (controller) => mapController = controller, myLocationEnabled: true, myLocationButtonEnabled: false, mapType: MapType.normal, initialCameraPosition: CameraPosition(zoom: 18, target: LatLng(userLocation!.latitude, userLocation.longitude))),
          //     );
          //   },
          // ),
          //this is the new implementation
          ProgressiveMapWidget(
            locationStream: locationStream,
            onMapCreated: (controller) => mapController = controller,
            availableDrivers: authVm.allDrivers,
            onLocationFound: () {
              // Called when location is found and animation completes
              setState(() {
                onFirstLocationTry = false;
              });
            },
          ),
          Positioned(
            left: 0.25.sw,
            right: 0.25.sw,
            top: kToolbarHeight + 15.h,
            child: HomeTopContainer()
          ),
          if(!isAvailableCars) Positioned(
            left: 24,
            right: 24,
            bottom: 88.h,
            child: BottomCardWidget(
              onBtnTap: () {
                if (locationController.text.isEmpty) {
                  dialog.showSnackBar("No destination Input", "Please enter a valid destination/stop");
                  return;
                }
                setState(() {
                  isAvailableCars = true;
                  destination = locationController.text;
                });
              },
              locationController: locationController,
            ),
          ),
          if(isAvailableCars && !isRiderComing) Positioned(
            left: 24,
            right: 24,
            bottom: 88.h,
            child: ShowAvailableCarsWidget(onBtnTap: () {
              setState(() {
                isRiderComing = true;
              });
            },
              destination: destination,
            )
          ),
          if(isRiderComing) Positioned(
              left: 24,
              right: 24,
              bottom: 88.h,
              child: Container(
                width: 321.w,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                child: DriverEnRouteCard()
              )
          ),
        ],
      ),
    );
  }
}
