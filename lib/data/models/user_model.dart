import 'package:ridex/data/models/driver_model.dart';
import 'package:ridex/data/models/ride_model.dart';

class AuthModel {
  String? message;
  String? token;
  UserModel? user;

  AuthModel({
    this.message,
    this.token,
    this.user,
  });

  factory AuthModel.fromJson(Map<dynamic, dynamic> json) => AuthModel(
    message: json["message"],
    token: json["token"],
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "user": user?.toJson(),
  };
}

class UserModel {
  int? id;
  String? avatar;
  String? fullName;
  String? email;
  String? walletAddress;
  String? country;
  List<double>? currentLocation;
  bool? isDriver;
  String? phoneNumber;
  DriverModel? driver;
  List<RideModel>? userRides;

  UserModel({
    this.id,
    this.avatar,
    this.fullName,
    this.email,
    this.driver,
    this.walletAddress,
    this.country,
    this.isDriver,
    this.currentLocation,
    this.phoneNumber,
    this.userRides,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
    id: json["id"],
    avatar: json["avatar"],
    fullName: json["full_name"],
    email: json["email"],
    country: json["country"],
    walletAddress: json["wallet_address"],
    isDriver: json["is_driver"],
    driver: json["driver"] == null ? null : DriverModel.fromJson(json['driver']),
    currentLocation: json["current_location"] == null ? [] : List<double>.from(json["current_location"]!.map((x) => x?.toDouble())),
    userRides: json["user_rides"] == null ? [] : List<RideModel>.from(json["user_rides"]!.map((x) => RideModel.fromJson(x))),
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "full_name": fullName,
    "wallet_address": walletAddress,
    "email": email,
    "country": country,
    "driver": driver?.toJson(),
    "current_location": currentLocation == null ? [] : List<dynamic>.from(currentLocation!.map((x) => x)),
    "user_rides": userRides == null ? [] : List<dynamic>.from(userRides!.map((x) => x.toJson())),
    "phone_number": phoneNumber,
  };
}
