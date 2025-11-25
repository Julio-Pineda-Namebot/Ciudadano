import "package:ciudadano/features/auth/domain/params/auth_login_params.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthLoginUseCase {
  final AuthRepository _repository;

  const AuthLoginUseCase(this._repository);

  Future<Either<String, String>> call(AuthLoginParams params) {
    return _repository.login(params);
  }
}
