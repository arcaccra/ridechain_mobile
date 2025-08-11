import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridex/app/theme.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/data/models/driver_model.dart';
import 'package:ridex/services/login_service.dart';

import '../../../../core/core_constants/colors.dart';
import '../../../../core/core_constants/label.dart';
import '../../../../core/core_constants/media.dart';


class ProgressiveMapWidget extends StatefulWidget {
  final Stream<Position> locationStream;
  final Function(GoogleMapController) onMapCreated;
  final VoidCallback? onLocationFound;
  final List<DriverModel> availableDrivers;
  final Function(DriverModel)? onDriverTapped;
  const ProgressiveMapWidget({super.key, required this.locationStream, required this.onMapCreated, this.onLocationFound, this.availableDrivers = const [], this.onDriverTapped});

  @override
  State<ProgressiveMapWidget> createState() => _ProgressiveMapWidgetState();
}

class _ProgressiveMapWidgetState extends State<ProgressiveMapWidget>  with TickerProviderStateMixin{

  GoogleMapController? _mapController;
  bool _isLocationFound = false;
  bool _hasAnimatedToLocation = false;
  Position? _userLocation;
  Set<Marker> _markers = {};
  BitmapDescriptor? _driverMarkerIcon;


  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  // Default camera position (you can set this to your city/country center)
  static final LatLng _defaultLocation = LatLng(Label.countryLat, Label.countryLng); // San Francisco
  static const double _defaultZoom = 10.0;
  static const double _userLocationZoom = 18.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeAnimations();
    _createCustomMarkerIcon();

  }

  //check for changes and update the widget appropriately
  @override
  void didUpdateWidget(ProgressiveMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableDrivers != widget.availableDrivers) {
      _updateDriverMarkers();
    }
  }

  //initialize the animations
  void _initializeAnimations() {
    // Pulse animation for loading indicator
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Fade animation for smooth transitions
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }

  //animate the camera to the user location
  Future<void> _animateToUserLocation(Position position) async {
    if (_mapController == null || _hasAnimatedToLocation) return;

    setState(() {
      _userLocation = position;
      _isLocationFound = true;
      _hasAnimatedToLocation = true;
    });

    // Stop pulse animation and start fade animation
    _pulseController.stop();
    _fadeController.forward();

    // Animate camera to user location with smooth zoom
    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _userLocationZoom,
          tilt: 0,
          bearing: 0,
        ),
      ),
    );

    // Callback when location is found and animated to
    widget.onLocationFound?.call();
  }

  //Create custom marker icon for drivers
  Future<void> _createCustomMarkerIcon() async {
    _driverMarkerIcon = await locator<LoginService>().svgToBitmap(context: context, svgAssetPath: Media.car);
    if (mounted) {
      _updateDriverMarkers();
    }
  }

  //get the driver markers
  // Update driver markers on map
  void _updateDriverMarkers() {
    if (_driverMarkerIcon == null) return;

    final Set<Marker> newMarkers = {};

    for (final driver in widget.availableDrivers) {
      if (driver.online!) {
        newMarkers.add(
          Marker(
            markerId: MarkerId('driver_${driver.id}'),
            position: driver.latLng,
            icon: _driverMarkerIcon!,
            //onTap: () => _onDriverMarkerTapped(driver),
            infoWindow: InfoWindow(
              title: driver.user?.fullName,
              snippet: '${driver.vehicleType} • ⭐ ${driver.vehiclePlateNumber}',
            ),
          ),
        );
      }
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Google Map - Always Visible
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: StreamBuilder<Position>(
            stream: widget.locationStream,
            builder: (context, snapshot) {
              // Handle errors gracefully
              if (snapshot.hasError) {
                _showLocationError();
              }

              // When location is received, animate to it
              if (snapshot.hasData && !_hasAnimatedToLocation) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _animateToUserLocation(snapshot.data!);
                });
              }

              return GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  widget.onMapCreated(controller);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateDriverMarkers();
                  });
                },
                myLocationEnabled: _isLocationFound,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: _defaultLocation,
                  zoom: _defaultZoom,
                ),
                // Add custom styling for better UX
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: true,
              );
            },
          ),
        ),

        // Loading Overlay - Only shows while getting location
        if (!_isLocationFound)
          _buildLoadingOverlay(),

        // Success Animation - Shows when location is found
        if (_isLocationFound && _fadeController.isAnimating)
          _buildSuccessAnimation(),
      ],
    );
  }
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated location icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_searching,
                        size: 32,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                },
              ),
              Gap(16),
              Text(
                Label.findingLocation,
                style: AppThemes.appBeauSansMedium
              ),
              Gap(8),
              Text(
                Label.mayTakeSeconds,
                style: AppThemes.getCustomTextStyle(
                  fontSize: 14,
                  weight: FontWeight.w400
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _fadeAnimation.value,
          child: Container(
            color: Colors.green.withValues(alpha: 0.1 * (1.0 - _fadeAnimation.value)),
            child: Center(
              child: Transform.scale(
                scale: 1.0 + (_fadeAnimation.value * 0.2),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        spreadRadius: 10,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLocationError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text(Label.unableToGetLocation),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: Label.retry,
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _isLocationFound = false;
                _hasAnimatedToLocation = false;
              });
              _pulseController.repeat(reverse: true);
              _fadeController.reset();
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
