import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/location_service.dart';
import 'package:ridex/ui/screens/home/bottom_card_widget.dart';
import 'package:ridex/ui/screens/home/show_available_cars.dart';
import 'package:ridex/ui/screens/home/widget/progressive_map_widget.dart';
import 'package:ridex/ui/shared_widgets/driver_en_route_card.dart';
import 'package:ridex/ui/shared_widgets/loader.dart';
import 'package:ridex/ui/shared_widgets/ride_searching_loader.dart';
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
  late RideProvider rideProvider;

  //call the app to get the location

  //TODO: load drivers markers for visualization

  //show searching available cars
  bool isAvailableCars = false;
  bool isRiderComing = false;
  String? destination;

  bool onFirstLocationTry = true;


  @override
  void initState() {
    //TODO: Activate fetch the driver details and show them on the map
    authVm = context.read<AuthVm>();
    rideProvider = context.read<RideProvider>();
    super.initState();
    authVm.getAllDrivers();
    authVm.getLocations();
    // Initialize your location stream here
    location.startListeningToPosition();
  }

  void _onDestinationSubmit() {
    if (locationController.text.trim().isEmpty) {
      dialog.showSnackBar(
          "No destination Input",
          "Please enter a valid destination/drop off"
      );
      return;
    }

    setState(() {
      destination = locationController.text.trim();
      rideProvider.fetchRides(destination!);
    });
  }


  //reset to idle
  void _resetToIdle() {
    setState(() {
      rideProvider.updateRideState(RideState.idle);
      destination = null;
      locationController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    authVm = context.watch<AuthVm>();
    rideProvider = context.watch<RideProvider>();
    return Scaffold(
      body: Stack(
        children: [
          //this is the new implementation
          buildMapWidget(),

          buildTopContainer(),

          //build the bottom card
          buildBottomCard(),
        ],
      ),
    );
  }

  //build map widget
  Widget buildMapWidget() {
    return ProgressiveMapWidget(
      locationStream: location.stream,
      onMapCreated: (controller) => mapController = controller,
      availableRides: rideProvider.rides,
      onLocationFound: () {
        // Called when location is found and animation completes
        setState(() {
          onFirstLocationTry = false;
        });
      },
    );
  }

  //build top container
  Widget buildTopContainer() {
    return Positioned(
        left: 0.25.sw,
        right: 0.25.sw,
        top: kToolbarHeight + 15.h,
        child: HomeTopContainer(title: destination,)
    );
  }

  //build bottom card
  Widget buildBottomCard() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 88.h,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _buildCurrentCard(),
      ),
    );
  }

  //build the current card to show
  _buildCurrentCard(){
    switch (rideProvider.currentRideState) {
      case RideState.idle:
        return _buildDestinationInputCard();

      case RideState.carsAvailable:
        return _buildAvailableCarsCard();

      case RideState.riderEnRoute:
        return _buildDriverEnRouteCard();

      case RideState.searchingCars:
        return _buildLoadingCard();

      case RideState.awaitingDriverResponse:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  //build the destination input card
  Widget _buildDestinationInputCard() {
    return BottomCardWidget(
      onBtnTap: () {
        //function called when the destination has been submitted
        _onDestinationSubmit();
      },
      locationController: locationController,
    );
  }

  //show available drivers card
  _buildAvailableCarsCard() {
    return ShowAvailableCarsWidget(
      locationStream: location.stream,
      onBtnTap: () {
      setState(() {
        isRiderComing = true;
      });
    },
      destination: destination,
    );
  }

  //build the driver en route card
  _buildDriverEnRouteCard(){
    return Container(
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
        //TODO: add an ontap to reset to idle when the page is closed
        child: DriverEnRouteCard()
    );
  }

  //build loader card
  _buildLoadingCard(){
    return RideSearchingLoader();
  }
}
