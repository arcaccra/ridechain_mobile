


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridex/data/models/user_model.dart';

class DriverModel {
  int? id;
  UserModel? user;
  String? idType;
  String? idNumber;
  String? vehiclePlateNumber;
  String? vehicleType;
  String? vehicleColor;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? status;
  bool? online;

  DriverModel({
    this.id,
    this.user,
    this.idType,
    this.idNumber,
    this.vehiclePlateNumber,
    this.vehicleType,
    this.vehicleColor,
    this.dateCreated,
    this.dateUpdated,
    this.status,
    this.online,
  });

  factory DriverModel.fromJson(Map<dynamic, dynamic> json) => DriverModel(
    id: json["id"],
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    idType: json["id_type"],
    idNumber: json["id_number"],
    vehiclePlateNumber: json["vehicle_plate_number"],
    vehicleType: json["vehicle_type"],
    vehicleColor: json["vehicle_color"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    dateUpdated: json["date_updated"] == null ? null : DateTime.parse(json["date_updated"]),
    status: json["status"],
    online: json["online"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "id_type": idType,
    "id_number": idNumber,
    "vehicle_plate_number": vehiclePlateNumber,
    "vehicle_type": vehicleType,
    "vehicle_color": vehicleColor,
    "date_created": dateCreated?.toIso8601String(),
    "date_updated": dateUpdated?.toIso8601String(),
    "status": status,
    "online": online,
  };

  LatLng get latLng => LatLng(user!.currentLocation![0], user!.currentLocation![1]);
}