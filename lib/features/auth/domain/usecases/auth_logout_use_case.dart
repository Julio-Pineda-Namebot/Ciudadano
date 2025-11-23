import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";

class AuthLogoutUseCase {
  final AuthRepository _authRepository;

  AuthLogoutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.logout();
  }
}
