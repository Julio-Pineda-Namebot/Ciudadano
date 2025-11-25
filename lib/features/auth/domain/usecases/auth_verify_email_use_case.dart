import "package:ciudadano/features/auth/domain/params/auth_verify_email_params.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthVerifyEmailUseCase {
  final AuthRepository _repository;

  const AuthVerifyEmailUseCase(this._repository);

  Future<Either<String, String>> call(AuthVerifyEmailParams params) {
    return _repository.verifyEmail(params);
  }
}
