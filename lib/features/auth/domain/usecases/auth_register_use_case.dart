import "package:ciudadano/features/auth/domain/params/auth_register_params.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:dartz/dartz.dart";

class AuthRegisterUseCase {
  final AuthRepository repository;

  const AuthRegisterUseCase(this.repository);

  Future<Either<String, void>> call(AuthRegisterParams params) {
    return repository.register(params);
  }
}
