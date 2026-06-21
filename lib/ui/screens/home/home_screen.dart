import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ridex/core/core_constants/label.dart';
import 'package:ridex/providers/auth_provider.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/fcm_service.dart';
import 'package:ridex/services/location_service.dart';
import 'package:ridex/ui/screens/home/bottom_card_widget.dart';
import 'package:ridex/ui/screens/home/show_available_cars.dart';
import 'package:ridex/ui/screens/home/widget/progressive_map_widget.dart';
import 'package:ridex/ui/screens/pay_for_trip/pay_for_trip.dart';
import 'package:ridex/ui/screens/rate_driver/rate_driver_screen.dart';
import 'package:ridex/ui/screens/ride_arrival_estimation/ride_arrival_screen.dart';
import 'package:ridex/ui/screens/ride_confirmation/confirm_ride.dart';
import 'package:ridex/ui/shared_widgets/driver_car_detail_card.dart';
import 'package:ridex/ui/shared_widgets/driver_en_route_card.dart';
import 'package:ridex/ui/shared_widgets/loader.dart';
import 'package:ridex/ui/shared_widgets/ride_searching_loader.dart';
import 'package:ridex/ui/shared_widgets/top_container.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../data/locator.dart';
import '../../../services/dialog_service.dart';
import '../auth/wallet_information.dart';

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

  // FCM listener subscription — must be cancelled in dispose to prevent leak
  StreamSubscription? _rideStatusSub;

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
    // authVm.getAllDrivers();
    // authVm.getLocations();
    // // Initialize your location stream here
    // //location.startListeningToPosition();
    // FCMService.instance.saveAnActivateTokenRefresh(authVm.currentUser!.id.toString());
    //_listenToRemoteMessagesFromRide();
    _initializeApp();
  }

  @override
  void dispose() {
    locationController.dispose();
    _rideStatusSub?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    if (!mounted) return;

    try {
      authVm = context.read<AuthVm>();
      rideProvider = context.read<RideProvider>();

      if (authVm.currentUser?.id == null) {
        dialog.showSnackBar(
            "Authentication Error",
            "User session not found. Please login again.",
            isError: true,
        );
        return;
      }

      authVm.getAllDrivers();
      authVm.getLocations();

      // ✅ REMOVE THIS - location already initialized by navigation screen
      // location.startListeningToPosition();

      // // ✅ Only check if location is already running
      // if (!location.stream) {
      //   // Location wasn't started by navigation screen, start it now
      //   bool hasPermission = await location.checkLocationPermission(context);
      //   if (hasPermission && mounted) {
      //     location.startListeningToPosition();
      //   }
      // }

      final userId = authVm.currentUser!.id.toString();
      await FCMService.instance.saveAnActivateTokenRefresh(userId);

      _listenToRemoteMessagesFromRide();

    } catch (e, stackTrace) {
      log('Initialization error: $e', stackTrace: stackTrace);
      if (mounted) {
        dialog.showSnackBar(
            "Initialization Error",
            "Failed to initialize: ${e.toString()}",
            isError: true,
        );
      }
    }
  }

  //listen to remote messages
  _listenToRemoteMessagesFromRide(){
    _rideStatusSub = FCMService.instance.listenToMessageReceivedForRideStatus((data) async {
      if(!mounted) return;

      String? status = data['status'];
      String? rideUUid = data['ride_uuid'];

      //TODO: fetch active trip and update the state
      if(status != null) {

        if(status == 'started') {
          rideProvider.updateRideState(RideState.tripStarted);
        } else if(status == 'approaching_pickup') {
          bool success = await rideProvider.fetchCurrentActiveRide(rideUUid!);
          if(success) {
            rideProvider.updateRideState(RideState.riderEnRoute);
          }
        }
        else if(status == 'completed') {
          if(authVm.currentUser?.walletAddress != null){
            Get.to(()=> RateDriverScreen());
          } else {
            Get.to(()=> PayForTrip());
          }
        }
        else if(status == 'arrived_pickup') {
          rideProvider.updateRideState(RideState.driverAtLocation);
        }
      }
    });
  }

  void _onDestinationSubmit([String? dest]) {
    final text = dest ?? locationController.text.trim();
    if (text.isEmpty) {
      dialog.showSnackBar(
          "No destination Input",
          "Please enter a valid destination/drop off",
          isError: true,
      );
      return;
    }

    setState(() {
      destination = text;
      rideProvider.fetchRides(destination!);
      locationController.text = "";
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


  Widget _buildWalletWarningBanner() {
    return Positioned(
      bottom: 90.h + 90.h,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () => Get.to(() => const WalletInfo()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFD700), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFB45309), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No wallet linked — you cannot book rides without a Cardano wallet address.',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    weight: FontWeight.w400,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB45309),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Add now',
                  style: AppThemes.getCustomTextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

          // Wallet warning banner
          if (authVm.walletAddress == null) _buildWalletWarningBanner(),
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
      approachingPickup: (){
        rideProvider.updateRideState(RideState.driverAtLocation);
      },
      approachingDestination: (){
        locator<DialogService>().showAlertDialog(
        context: context,
        message: Label.approachingDestination, type: AlertDialogType.error, okayText: Label.yes,
        cancelText: Label.no,
            onCancelBtnTap: (){
          Navigator.pop(context);
        },
        onOkayBtnTap: (){
          Navigator.pop(context);
          if(authVm.userWallet?.address == null){
            Get.to(()=> RateDriverScreen());
          } else {
            Get.to(()=> PayForTrip());
          }
        });
      },
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
      top: MediaQuery.of(context).padding.top + 12.h,
      left: 0,
      right: 0,
      child: HomeTopContainer(title: destination),
    );
  }

  //build bottom card
  Widget buildBottomCard() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 140.h,
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
        return _buildShowDriverDetailCard();
      case RideState.driverAtLocation:
        return _buildDriverIsHere();
      case RideState.tripStarted:
        return _showTripStartedCard();
      // case RideState.tripEnded:
      //   return _buildTripHasEnded();
    }
  }

  _buildDriverIsHere(){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primaryColor.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: DriverEnRouteCard(
        ride: rideProvider.selectedRide,
        hasArrived: true,
        onCancelTap: () => rideProvider.updateRideState(RideState.tripStarted),
      ),
    );
  }

  _buildTripHasEnded(){
    return RideSearchingLoader(
      notLoadingState: true,
      title: Label.rideEnded,
      noLoadingText: Label.makePayment,
      height: 0.4.sh,
      fontSize: 20,
      onBtnTap: (){
        if(authVm.currentUser?.walletAddress != null){
          Get.to(()=> RateDriverScreen());
        } else {
          Get.to(()=> PayForTrip());
        }

      },
    );
  }

  //build the destination input card
  Widget _buildDestinationInputCard() {
    return BottomCardWidget(
      onDestinationSubmit: _onDestinationSubmit,
      locationController: locationController,
    );
  }

  //show available drivers card
  _buildAvailableCarsCard() {
    return ShowAvailableCarsWidget(
      locationStream: location.stream,
      onBtnTap: () async{
        locator<DialogService>().showCustomModal(
            context: context,
            isDismissible: false,
            customModal: ConfirmRide(
              ride: rideProvider.selectedRide!,
              onCancelTap: (){
                Navigator.pop(context);
              },
              onConfirmTap: (seats) async {
                Navigator.pop(context);
                await rideProvider.bookRide(rideProvider.selectedRide!.uuid!, authVm.currentUser!.id.toString());
              },)
        );
    },
      onCancelTap: (){
        rideProvider.resetRideState();
      },
      destination: destination,
    );
  }

  //build the driver en route card
  _buildDriverEnRouteCard(){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primaryColor.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: DriverEnRouteCard(
        ride: rideProvider.selectedRide,
        onCancelTap: () => rideProvider.resetRideState(),
      ),
    );
  }

  //build loader card
  _buildLoadingCard(){
    return RideSearchingLoader(
      destination: destination,
      onBtnTap: _resetToIdle,
    );
  }

  _buildShowDriverDetailCard(){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
        child: DriverCarDetailWidget(ride: rideProvider.selectedRide!,)
    );
  }

  _showTripStartedCard() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
        child: RideArrivalScreen(
          ride: rideProvider.selectedRide!,
          atDropOff: (){
            if(authVm.currentUser?.walletAddress != null){
              Get.to(()=> RateDriverScreen());
            } else {
              Get.to(()=> PayForTrip());
            }
            //rideProvider.updateRideState(RideState.tripEnded);
          },
        )
    );
  }
}
