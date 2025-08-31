

import 'package:ridex/data/models/ride_model.dart';
import 'package:ridex/providers/base_provider.dart';
import '../data/models/api_response.dart';

enum RideState {
  idle,           // Initial state - show destination input
  searchingCars, // state when searching for ride
  carsAvailable, // show when the cars are available
  riderEnRoute,   // Driver is coming
}

class RideProvider extends BaseProvider {


  List<RideModel> rides = [];

  RideModel? selectedRide;

  RideState currentRideState = RideState.idle;

  fetchRides(String destination) async {
    setUiState(UiState.loading);
    updateRideState(RideState.searchingCars);
    try {
      var response = await rideService.getAllRidesBasedOnLocation(destination);
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.allGood!) {
        List ridesData = List.from(apiResponse.listWithoutDataKey);
        if(ridesData.isNotEmpty) {
          ridesData = ridesData.map((e)=> RideModel.fromJson(e)).toList();
          updateRideState(RideState.carsAvailable);
        } else {
          updateRideState(RideState.idle);
        }
      }
    } on Exception catch(e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString());
    } finally {
      setUiState(UiState.done);
    }
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
    notifyListeners();
  }



}