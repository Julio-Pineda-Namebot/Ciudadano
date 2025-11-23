import "package:equatable/equatable.dart";

class AuthProfile extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String dni;
  final String phone;

  const AuthProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dni,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, dni, phone];
}
