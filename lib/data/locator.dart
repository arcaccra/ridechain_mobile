

import 'package:get_it/get_it.dart';
import 'package:ridex/services/connectivity_service.dart';
import 'package:ridex/services/location_service.dart';

import '../services/dialog_service.dart';

final GetIt locator = GetIt.instance;



void setUpLocator() {
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<ConnectionService>(() => ConnectionService());
}