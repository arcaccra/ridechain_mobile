class AuthModel {
  int id;
  String? avatar;
  String? fullName;
  String? email;
  String? country;
  String? phoneNumber;
  String? token;
  bool isActive;
  bool isDriver;

  AuthModel({required this.id, this.avatar, this.fullName, this.email, this.country, this.phoneNumber, this.token, required this.isActive, required this.isDriver});

  factory AuthModel.fromJson(Map<dynamic, dynamic> json) =>
      AuthModel(id: json["id"], avatar: json["avatar"], fullName: json["full_name"], email: json["email"], country: json["country"], phoneNumber: json["phone_number"], isActive: json["is_active"], token: json["token"], isDriver: json["is_driver"]);

  Map<String, dynamic> toJson() => {"id": id, "avatar": avatar, "full_name": fullName, "email": email, "country": country, "phone_number": phoneNumber, "token": token, "is_active": isActive, "is_driver": isDriver};
}
