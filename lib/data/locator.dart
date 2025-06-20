

import 'package:get_it/get_it.dart';

import '../services/dialog_service.dart';

final GetIt locator = GetIt.instance;



void setUpLocator() {
  locator.registerLazySingleton<DialogService>(() => DialogService());
}