import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";

class AuthProfileModel extends AuthProfile {
  const AuthProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.dni,
    required super.phone,
  });

  factory AuthProfileModel.fromJson(Map<String, dynamic> json) {
    return AuthProfileModel(
      id: json["id"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      email: json["email"] as String,
      dni: json["dni"] as String,
      phone: json["phone"] as String,
    );
  }
}
