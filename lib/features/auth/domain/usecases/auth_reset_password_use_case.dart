import "package:ciudadano/features/auth/domain/params/auth_reset_password_params.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthResetPasswordUseCase {
  final AuthRepository _repository;

  const AuthResetPasswordUseCase(this._repository);

  Future<Either<String, String>> call(AuthResetPasswordParams params) {
    return _repository.resetPassword(params);
  }
}
