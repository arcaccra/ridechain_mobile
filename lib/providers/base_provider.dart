import 'package:flutter/cupertino.dart';
import 'package:ridex/services/image_service.dart';
import 'package:ridex/services/rides_service.dart';
import 'package:ridex/services/trip_firebase_service.dart';

import '../data/locator.dart';
import '../services/dialog_service.dart';
import '../services/login_service.dart';

enum UiState { idle, loading, done, error }

class BaseProvider with ChangeNotifier {
  var auth = locator<LoginService>();
  var dialog = locator<DialogService>();
  var image = locator<ImageService>();
  var rideService = locator<RidesService>();
  var tripService = locator<TripFirebaseService>();

  UiState uiState = UiState.idle;

  // Guard flag — prevents notifyListeners / state mutations after dispose
  bool _disposed = false;

  bool get isLoading => uiState == UiState.loading;
  bool get done => uiState == UiState.done;
  bool get error => uiState == UiState.error;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Safe notifyListeners — silently no-ops after dispose.
  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  /// Set UI state and notify. No-ops after dispose.
  void setUiState(UiState state) {
    if (_disposed) return;
    uiState = state;
    notifyListeners();
  }

  /// Run [func] then notify listeners. No-ops after dispose.
  void updateUi(VoidCallback func) {
    if (_disposed) return;
    func();
    notifyListeners();
  }
}
