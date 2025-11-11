

import 'dart:developer' as developer;

import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/providers/base_provider.dart';
import '../data/models/api_response.dart';
import '../data/models/booked_model.dart';

enum RideState {
  idle,           // Initial state - show destination input
  searchingCars, // state when searching for ride
  carsAvailable, // show when the cars are available
  awaitingDriverResponse, // Awaiting driver response
  driverAtLocation, // driver at location
  tripStarted, // trip started
  tripEnded, // trip ended
  riderEnRoute, // Driver is coming
}

class RideProvider extends BaseProvider {


  List<RideModel> rides = [];

  RideModel? selectedRide;

  BookedRideModel? bookedRide;

  String selectedRideId = "";

  RideState currentRideState = RideState.idle;

  fetchRides(String destination) async {
    setUiState(UiState.loading);
    updateRideState(RideState.searchingCars);
    try {
      var response = await rideService.getAllRidesBasedOnLocation(destination);
      developer.log(response.toString());
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.allGood!) {
        List ridesData = List.from(apiResponse.listWithoutDataKey);
        if(ridesData.isNotEmpty) {
          rides = ridesData.map((e)=> RideModel.fromJson(e)).toList();
          updateRideState(RideState.carsAvailable);
        } else {
          updateRideState(RideState.idle);
          dialog.showSnackBar("Oops😫", "No rides found with the search parameters");
        }
      }
    } on Exception catch(e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString());
    } finally {
      setUiState(UiState.done);
    }
  }

  bookRide(String rideId, String userId) async {
    setUiState(UiState.loading);
    updateRideState(RideState.awaitingDriverResponse);
    try {
      var response = await rideService.bookRide(rideId);
      developer.log(response.toString());
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.allGood!) {
        bookedRide = BookedRideModel.fromJson(apiResponse.mappedObjects!);
        await tripService.requestToJoinTrip(rideId, userId);
        updateRideState(RideState.riderEnRoute);
      } else {
        dialog.showSnackBar("An unexpected error occurred", apiResponse.message!);
        updateRideState(RideState.carsAvailable);
      }
    } on Exception catch(e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString());
    } finally {
      setUiState(UiState.done);
    }
  }

  Future<bool> rateTrip(Map<String, dynamic> body) async {
    setUiState(UiState.loading);
    updateRideState(RideState.awaitingDriverResponse);
    try {
      var response = await rideService.rateRide(body);
      developer.log(response.toString());
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.allGood!) {
        return true;
      }
    } on Exception catch(e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString());
    } finally {
      setUiState(UiState.done);
    }
    return false;
  }


  // Improved state management methods
  void updateRideState(RideState newState) {
    if (currentRideState != newState) {
        currentRideState = newState;
    }
    notifyListeners();
  }

  setSelectedRide(RideModel ride) {
    selectedRide = ride;
    selectedRideId = ride.uuid!;
    notifyListeners();
  }

  reset(){
    selectedRide = null;
    selectedRideId = "";
    notifyListeners();
  }


  resetRideState() {
    currentRideState = RideState.idle;
    rides.clear();
    selectedRide = null;
    selectedRideId = "";
    bookedRide = null;
    notifyListeners();
  }

}