import "package:ciudadano/features/sidebar/profile/entities/user_profile.dart";

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.dni,
    required super.email,
    required super.phone,
    required super.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      dni: json["dni"] ?? "",
      email: json["email"],
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "dni": dni,
    "email": email,
    "phone": phone,
    "address": address,
  };
}
