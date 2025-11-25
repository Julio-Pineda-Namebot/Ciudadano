import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthSendResetPasswordEmailUseCase {
  final AuthRepository _repository;

  const AuthSendResetPasswordEmailUseCase(this._repository);

  Future<Either<String, String>> call(String email) {
    return _repository.sendResetPasswordEmail(email);
  }
}
