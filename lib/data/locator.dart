

import 'package:get_it/get_it.dart';
import 'package:ridex/services/connectivity_service.dart';
import 'package:ridex/services/image_service.dart';
import 'package:ridex/services/location_service.dart';
import 'package:ridex/services/login_service.dart';
import 'package:ridex/services/rides_service.dart';
import 'package:ridex/services/trip_firebase_service.dart';
import 'package:ridex/ui/screens/auth/login_screen.dart';

import '../services/dialog_service.dart';

final GetIt locator = GetIt.instance;



void setUpLocator() {
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<LoginService>(() => LoginService());
  locator.registerLazySingleton<ImageService>(() => ImageService());
  locator.registerLazySingleton<RidesService>(() => RidesService());
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<TripFirebaseService>(() => TripFirebaseService());
  locator.registerLazySingleton<ConnectionService>(() => ConnectionService());
}