

import 'package:ridex/data/constants/api_constants.dart';
import 'package:ridex/providers/rides_provider.dart';
import 'package:ridex/services/http_service.dart';
import 'package:dio/dio.dart' as dio;

import '../data/models/ride_model.dart';

class RidesService extends HttpService {


  //get rides for destination
  getAllRidesBasedOnLocation(String destination) async {
    var response = await get("${Api.rides}rides/search/?drop_off=$destination");
    return response;
  }

  //get rides for destination
  rateRide(Map<String, dynamic> data) async {
    var body = dio.FormData.fromMap(data);
    var response = await post(Api.ratings, body: body);
    return response;
  }


  //book a ride
  bookRide(String rideId) async {
    var response = await post("${Api.rides}rides/$rideId/book/");
    return response;
  }

  //get the ride details by ID
  getRideById(String rideId) async {
    var response = await get("${Api.rides}rides/$rideId/");
    return response;
  }

  //cancel a ride
  cancelRide(String rideId, int userId) async {
    var response = await post("${Api.rides}cancel-booking/$userId/$rideId/");
    return response;
  }



  checkIfTripHasStarted({RideModel? model, required RideState rideState}) {
    return model != null && rideState == RideState.tripStarted;
  }


}