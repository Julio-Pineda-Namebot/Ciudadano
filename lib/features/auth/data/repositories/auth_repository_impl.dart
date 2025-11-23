import "package:ciudadano/features/auth/data/interceptors/auth_interceptor.dart";
import "package:ciudadano/features/auth/data/sources/auth_api_source.dart";
import "package:ciudadano/features/auth/data/sources/auth_secure_storage_source.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/domain/params/auth_login_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_register_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_reset_password_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_verify_email_params.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:ciudadano/service_locator.dart";
import "package:dartz/dartz.dart";

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiSource _apiSource;
  final AuthSecureStorageSource _secureStorageSource;

  const AuthRepositoryImpl(this._apiSource, this._secureStorageSource);

  @override
  Future<Either<String, String>> login(AuthLoginParams params) {
    return _apiSource
        .login(params)
        .then(
          (result) => result.fold((l) => Left(l), (token) async {
            await _secureStorageSource.saveToken(token);
            sl<AuthInterceptor>().setToken(token);
            return Right(token);
          }),
        );
  }

  @override
  Future<Either<String, String>> register(AuthRegisterParams params) {
    return _apiSource.register(params);
  }

  @override
  Future<Either<String, String>> verifyEmail(AuthVerifyEmailParams params) {
    return _apiSource.verifyEmail(params);
  }

  @override
  Future<Either<String, String>> resendVerificationEmail(String email) {
    return _apiSource.resendVerificationEmail(email);
  }

  @override
  Future<Either<String, String>> resetPassword(AuthResetPasswordParams params) {
    return _apiSource.resetPassword(params);
  }

  @override
  Future<Either<String, String>> sendResetPasswordEmail(String email) {
    return _apiSource.sendResetPasswordEmail(email);
  }

  @override
  Future<AuthProfile?> getProfileIfUserIsAuthenticated() async {
    final token = await _secureStorageSource.getToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    sl<AuthInterceptor>().setToken(token);

    final result = await _apiSource.getProfile();

    return result.fold((l) => null, (authProfile) => authProfile);
  }
}
