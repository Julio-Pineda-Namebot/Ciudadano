import "package:equatable/equatable.dart";

class UserProfileState extends Equatable {
  final String id;
  final String name;
  final String dni;
  final String email;
  final String phone;
  final String address;
  final bool pushNotifications;

  const UserProfileState({
    this.id = "",
    this.name = "",
    this.dni = "",
    this.email = "",
    this.phone = "",
    this.address = "",
    this.pushNotifications = false,
  });

  UserProfileState copyWith({
    String? id,
    String? name,
    String? dni,
    String? email,
    String? phone,
    String? address,
    bool? pushNotifications,
  }) {
    return UserProfileState(
      id: id ?? this.id,
      name: name ?? this.name,
      dni: dni ?? this.dni,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      pushNotifications: pushNotifications ?? this.pushNotifications,
    );
  }

  @override
  List<Object?> get props => [
    name,
    dni,
    email,
    phone,
    address,
    pushNotifications,
  ];
}
