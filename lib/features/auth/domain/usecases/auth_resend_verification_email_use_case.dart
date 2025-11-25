import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthResendVerificationEmailUseCase {
  final AuthRepository _repository;

  const AuthResendVerificationEmailUseCase(this._repository);

  Future<Either<String, String>> call(String email) {
    return _repository.resendVerificationEmail(email);
  }
}
