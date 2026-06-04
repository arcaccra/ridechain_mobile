import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ridex/ui/shared_widgets/light_status_bar.dart';

import '../../../core/core_constants/colors.dart';
import '../../../data/locator.dart';
import '../../../services/dialog_service.dart';
import '../../../services/location_service.dart';
import '../../../services/nav_service.dart';
import '../../shared_widgets/bottom_nav.dart';



class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> with WidgetsBindingObserver{
  int currentIndex = 0;
  final location = locator<LocationService>();
  bool _hasInitializedLocation = false;

  changeTheCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }


  /// Initialize location services once
  Future<void> _initializeLocation() async {
    if (_hasInitializedLocation) return;

    try {
      await startListeningToUserPosition();
      _hasInitializedLocation = true;
    } catch (e) {
      log('Location initialization error: $e');
    }
  }

  Future<void> startListeningToUserPosition() async {
    if (!mounted) return;

    try {
      bool isLocationGranted = await location.checkLocationPermission(context);

      if (isLocationGranted && mounted) {
        location.startListeningToPosition();
      }
    } catch (e) {
      log('Error starting location listener: $e');
      if (mounted) {
        locator<DialogService>().showSnackBar(
            "Location Error",
            "Failed to start location services: ${e.toString()}",
            isError: true,
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // ✅ Clear permission cache when app resumes
    if (state == AppLifecycleState.resumed) {
      location.clearPermissionCache();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          NavService.selectedScreen(currentIndex)!,
          Positioned(
            right: 0,
            left: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: BottomNav(
              currentIndex: currentIndex,
              getCurrentIndex: (index) {
                changeTheCurrentIndex(index);
              },
            ).animate().fade().scale(delay: 500.ms),
          ),
        ],
      ),
    );
  }
}
