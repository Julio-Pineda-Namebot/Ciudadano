import "package:ciudadano/features/sidebar/profile/entities/user_profile.dart";

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.dni,
    required super.email,
    required super.phone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      dni: json["dni"] ?? "",
      email: json["email"],
      phone: json["phone"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "dni": dni,
    "email": email,
    "phone": phone,
  };
}
