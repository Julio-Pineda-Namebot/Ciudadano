import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthResendVerificationEmailUseCase {
  final AuthRepository repository;

  const AuthResendVerificationEmailUseCase(this.repository);

  Future<Either<String, String>> call(String email) {
    return repository.resendVerificationEmail(email);
  }
}
