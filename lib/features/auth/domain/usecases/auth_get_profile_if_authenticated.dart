import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";

class AuthGetProfileIfAuthenticated {
  final AuthRepository repository;

  const AuthGetProfileIfAuthenticated(this.repository);

  Future<AuthProfile?> call() {
    return repository.getProfileIfUserIsAuthenticated();
  }
}
