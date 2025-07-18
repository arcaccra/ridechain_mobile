import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../core/core_constants/label.dart';
import '../data/locator.dart';
import 'dialog_service.dart';


class LocationService {
  //check for location permission
  Future<bool> checkLocationPermission(BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        locator<DialogService>().showSnackBar(
            "Error", Label.noGPSPermission
        );
      }
      return false;
    }
    return true;
  }


  //calculate the distance and time
  Future<Map<String, dynamic>> calculateDistanceAndTime(double taskLat, double taskLng, double userLocationLat, double userLocationLng) async {
    double distanceInMeters = Geolocator.distanceBetween(taskLat, taskLng, userLocationLat, userLocationLng);
    double speed = 5.0; //assuming that the walkig speed is 5m/s
    double estimatedTime = distanceInMeters / speed;

    var map = {"distance" : distanceInMeters, "time": estimatedTime};
    return map;
  }

  //launch the url for google maps
  Future<void> launchGoogleMapsNavigation(double taskLat, double taskLng) async {
    final url = "https://www.google.com/maps/dir/?api=1&destination=$taskLat,$taskLng";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch Google Maps";
    }
  }

  //
  Future<void> checkGPSAccess() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      locator<DialogService>().showSnackBar(
          "Location Access Required",Label.checkGPSAccess
      );
    }
  }

  Future<Position> getUserLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    return currentPosition;
  }


  //create the stream for collecting data
  StreamSubscription? _subscription;

  final StreamController<Position> _controller = StreamController<Position>.broadcast();

  Stream<Position> get stream => _controller.stream;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0,
  );

  startListeningToPosition() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    _subscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((position) {
      _controller.add(position);
    });
  }

  stopListening() {
    _subscription!.cancel();
  }

  //get current location
  Future<Position> getCurrentUserLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }



  //open the map launcher
  showDirectionToDriver(double latitude, double longitude) async {
   await MapsLauncher.launchCoordinates(latitude, longitude, "Show direction to driver");
  }
}