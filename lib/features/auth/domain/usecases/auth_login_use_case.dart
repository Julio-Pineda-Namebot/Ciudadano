import "package:ciudadano/features/auth/domain/params/auth_login_params.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthLoginUseCase {
  final AuthRepository repository;

  const AuthLoginUseCase(this.repository);

  Future<Either<String, String>> call(AuthLoginParams params) {
    return repository.login(params);
  }
}
