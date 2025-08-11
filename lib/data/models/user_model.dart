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
  String? country;
  List<double>? currentLocation;
  String? phoneNumber;

  UserModel({
    this.id,
    this.avatar,
    this.fullName,
    this.email,
    this.country,
    this.currentLocation,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
