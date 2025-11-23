class AuthRegisterParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String dni;

  const AuthRegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dni,
  });
}
