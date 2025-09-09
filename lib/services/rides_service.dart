

import 'package:ridex/data/constants/api_constants.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/http_service.dart';

import '../data/models/ride_model.dart';

class RidesService extends HttpService {


  //get rides for destination
  getAllRidesBasedOnLocation(String destination) async {
    var response = await get("${Api.rides}rides/search/?drop_off=$destination");
    return response;
  }


  //book a ride
  bookRide(String rideId) async {
    var response = await post("${Api.rides}rides/$rideId/book/");
    return response;
  }

  checkIfTripHasStarted({RideModel? model, required RideState rideState}) {
    return model != null && rideState == RideState.tripStarted;
  }


}