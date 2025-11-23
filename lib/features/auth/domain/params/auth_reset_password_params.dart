class AuthResetPasswordParams {
  final String email;
  final String password;
  final String code;

  const AuthResetPasswordParams({
    required this.email,
    required this.password,
    required this.code,
  });
}
