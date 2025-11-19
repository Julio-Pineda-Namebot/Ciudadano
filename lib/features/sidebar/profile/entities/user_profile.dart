import "package:equatable/equatable.dart";

class UserProfile extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? dni;
  final String? email;
  final String? phone;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    dni,
    email,
    phone,
  ];
}
