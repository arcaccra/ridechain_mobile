


import 'dart:convert';

RideModel rideModelFromJson(String str) => RideModel.fromJson(json.decode(str));

String rideModelToJson(RideModel data) => json.encode(data.toJson());

class RideModel {
  String? uuid;
  Driver? driver;
  DropOff? pickUp;
  DropOff? dropOff;
  int? seatsAvailable;
  String? pricePerSeat;
  DateTime? createdAt;
  DateTime? updatedAt;

  RideModel({
    this.uuid,
    this.driver,
    this.pickUp,
    this.dropOff,
    this.seatsAvailable,
    this.pricePerSeat,
    this.createdAt,
    this.updatedAt,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
    uuid: json["uuid"],
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    pickUp: json["pick_up"] == null ? null : DropOff.fromJson(json["pick_up"]),
    dropOff: json["drop_off"] == null ? null : DropOff.fromJson(json["drop_off"]),
    seatsAvailable: json["seats_available"],
    pricePerSeat: json["price_per_seat"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "driver": driver?.toJson(),
    "pick_up": pickUp?.toJson(),
    "drop_off": dropOff?.toJson(),
    "seats_available": seatsAvailable,
    "price_per_seat": pricePerSeat,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Driver {
  int? id;
  User? user;
  String? idType;
  String? idNumber;
  String? vehiclePlateNumber;
  String? vehicleType;
  String? vehicleColor;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? status;
  bool? online;

  Driver({
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

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
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
}

class User {
  int? id;
  String? avatar;
  String? fullName;
  String? email;
  String? country;
  List<double>? currentLocation;
  String? phoneNumber;

  User({
    this.id,
    this.avatar,
    this.fullName,
    this.email,
    this.country,
    this.currentLocation,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    avatar: json["avatar"],
    fullName: json["full_name"],
    email: json["email"],
    country: json["country"],
    currentLocation: json["current_location"] == null ? [] : List<double>.from(json["current_location"]!.map((x) => x?.toDouble())),
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "full_name": fullName,
    "email": email,
    "country": country,
    "current_location": currentLocation == null ? [] : List<dynamic>.from(currentLocation!.map((x) => x)),
    "phone_number": phoneNumber,
  };
}

class DropOff {
  int? id;
  String? name;
  double? latitude;
  double? longitude;

  DropOff({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
  });

  factory DropOff.fromJson(Map<String, dynamic> json) => DropOff(
    id: json["id"],
    name: json["name"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
  };
}
