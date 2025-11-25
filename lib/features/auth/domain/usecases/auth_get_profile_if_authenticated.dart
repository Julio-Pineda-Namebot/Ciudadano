import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";

class AuthGetProfileIfAuthenticated {
  final AuthRepository _repository;

  const AuthGetProfileIfAuthenticated(this._repository);

  Future<AuthProfile?> call() {
    return _repository.getProfileIfUserIsAuthenticated();
  }
}
