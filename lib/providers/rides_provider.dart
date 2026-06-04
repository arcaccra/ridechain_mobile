import 'dart:developer' as developer;
import 'dart:ui';

import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/providers/base_provider.dart';

import '../data/models/api_response.dart';
import '../data/models/booked_model.dart';

enum RideState {
  idle, // Default — show destination input
  searchingCars, // API request in flight
  carsAvailable, // Search results ready
  awaitingDriverResponse, // Booking sent, waiting for driver accept
  riderEnRoute, // Driver accepted, en route to pickup
  driverAtLocation, // Driver arrived at pickup
  tripStarted, // Trip in progress
}

class RideProvider extends BaseProvider {
  List<RideModel> rides = [];
  RideModel? selectedRide;
  BookedRideModel? bookedRide;
  String selectedRideId = '';

  RideState currentRideState = RideState.idle;

  // ========================================
  // FETCH RIDES
  // ========================================
  Future<void> fetchRides(String destination) async {
    setUiState(UiState.loading);
    updateRideState(RideState.searchingCars);
    try {
      final response =
          await rideService.getAllRidesBasedOnLocation(destination);
      developer.log(response.toString());
      final apiResponse = ApiResponse.parse(response);

      if (apiResponse.allGood == true) {
        final ridesData = List.from(apiResponse.listWithoutDataKey);
        if (ridesData.isNotEmpty) {
          rides =
              ridesData.map((e) => RideModel.fromJson(e as Map<String, dynamic>)).toList();
          updateRideState(RideState.carsAvailable);
        } else {
          updateRideState(RideState.idle);
          dialog.showSnackBar(
              'No rides found', 'No rides match your search. Try a different destination.', isError: true);
        }
      } else {
        updateRideState(RideState.idle);
        dialog.showSnackBar(
            'Search failed', apiResponse.message ?? 'An unexpected error occurred.', isError: true);
      }
    } on Exception catch (e) {
      updateRideState(RideState.idle);
      dialog.showSnackBar('Search failed', e.toString(), isError: true);
    } finally {
      setUiState(UiState.done);
    }
  }

  // ========================================
  // BOOK RIDE
  // ========================================
  Future<void> bookRide(String rideId, String userId) async {
    setUiState(UiState.loading);
    try {
      final response = await rideService.bookRide(rideId);
      developer.log(response.toString());
      final apiResponse = ApiResponse.parse(response);

      if (apiResponse.allGood == true) {
        bookedRide =
            BookedRideModel.fromJson(apiResponse.mappedObjects as Map<String, dynamic>);
        await tripService.requestToJoinTrip(rideId, userId);
        // State stays awaitingDriverResponse — home screen listener handles navigation
        updateRideState(RideState.awaitingDriverResponse);
      } else {
        // Revert to carsAvailable so the user can choose again
        updateRideState(RideState.carsAvailable);
        dialog.showSnackBar(
            'Booking failed', apiResponse.message ?? 'An unexpected error occurred.', isError: true);
      }
    } on Exception catch (e) {
      updateRideState(RideState.carsAvailable);
      dialog.showSnackBar('Booking failed', e.toString(), isError: true);
    } finally {
      setUiState(UiState.done);
    }
  }

  // ========================================
  // CANCEL BOOKING
  // ========================================
  Future<void> cancelBooking(
    String rideId,
    int userId, {
    VoidCallback? onSuccess,
  }) async {
    setUiState(UiState.loading);
    try {
      final response = await rideService.cancelRide(rideId, userId);
      developer.log(response.toString());
      final apiResponse = ApiResponse.parse(response);

      if (apiResponse.allGood == true) {
        onSuccess?.call();
      } else {
        dialog.showSnackBar(
            'Cancellation failed', apiResponse.message ?? 'An unexpected error occurred.', isError: true);
      }
    } on Exception catch (e) {
      dialog.showSnackBar('Cancellation failed', e.toString(), isError: true);
    } finally {
      setUiState(UiState.done);
    }
  }

  // ========================================
  // RATE TRIP
  // ========================================
  Future<bool> rateTrip(Map<String, dynamic> body) async {
    setUiState(UiState.loading);
    try {
      final response = await rideService.rateRide(body);
      developer.log(response.toString());
      final apiResponse = ApiResponse.parse(response);

      if (apiResponse.allGood == true) {
        return true;
      } else {
        dialog.showSnackBar(
            'Rating failed', apiResponse.message ?? 'An unexpected error occurred.', isError: true);
      }
    } on Exception catch (e) {
      dialog.showSnackBar('Rating failed', e.toString(), isError: true);
    } finally {
      setUiState(UiState.done);
    }
    return false;
  }

  // ========================================
  // FETCH CURRENT ACTIVE RIDE
  // ========================================
  Future<bool> fetchCurrentActiveRide(String rideId) async {
    setUiState(UiState.loading);
    try {
      final response = await rideService.getRideById(rideId);
      developer.log(response.toString());
      final apiResponse = ApiResponse.parse(response);

      if (apiResponse.allGood == true && apiResponse.mappedObjects != null) {
        selectedRide =
            RideModel.fromJson(apiResponse.mappedObjects as Map<String, dynamic>);
        return true;
      }
    } on Exception catch (e) {
      dialog.showSnackBar('Could not load ride', e.toString(), isError: true);
    } finally {
      setUiState(UiState.done);
    }
    return false;
  }

  // ========================================
  // STATE HELPERS
  // ========================================

  void updateRideState(RideState newState) {
    if (currentRideState == newState) {
      // State unchanged — still notify so listeners can react
      notifyListeners();
      return;
    }
    currentRideState = newState;
    notifyListeners();
  }

  void setSelectedRide(RideModel ride) {
    selectedRide = ride;
    selectedRideId = ride.uuid ?? '';
    notifyListeners();
  }

  /// Full reset — clears all ride data and returns to idle.
  /// Use this at end of trip or on logout.
  void resetRideState() {
    currentRideState = RideState.idle;
    rides.clear();
    selectedRide = null;
    selectedRideId = '';
    bookedRide = null;
    notifyListeners();
  }
}
