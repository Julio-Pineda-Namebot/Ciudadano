import "package:ciudadano/features/auth/domain/params/auth_verify_email_params.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthVerifyEmailUseCase {
  final AuthRepository repository;

  const AuthVerifyEmailUseCase(this.repository);

  Future<Either<String, String>> call(AuthVerifyEmailParams params) {
    return repository.verifyEmail(params);
  }
}
