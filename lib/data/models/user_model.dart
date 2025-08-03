class AuthModel {
  String? message;
  String? token;
  User? user;

  AuthModel({
    this.message,
    this.token,
    this.user,
  });

  factory AuthModel.fromJson(Map<dynamic, dynamic> json) => AuthModel(
    message: json["message"],
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? avatar;
  String? fullName;
  String? email;
  String? country;
  String? phoneNumber;

  User({
    this.id,
    this.avatar,
    this.fullName,
    this.email,
    this.country,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    avatar: json["avatar"],
    fullName: json["full_name"],
    email: json["email"],
    country: json["country"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "full_name": fullName,
    "email": email,
    "country": country,
    "phone_number": phoneNumber,
  };
}
