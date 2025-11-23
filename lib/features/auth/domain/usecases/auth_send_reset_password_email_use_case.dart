import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthSendResetPasswordEmailUseCase {
  final AuthRepository repository;

  const AuthSendResetPasswordEmailUseCase(this.repository);

  Future<Either<String, String>> call(String email) {
    return repository.sendResetPasswordEmail(email);
  }
}
