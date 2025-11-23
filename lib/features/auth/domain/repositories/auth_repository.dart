import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/domain/params/auth_login_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_register_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_reset_password_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_verify_email_params.dart";
import "package:dartz/dartz.dart";

abstract class AuthRepository {
  Future<Either<String, String>> login(AuthLoginParams params);

  Future<Either<String, String>> register(AuthRegisterParams params);

  Future<Either<String, String>> verifyEmail(AuthVerifyEmailParams params);

  Future<Either<String, String>> resendVerificationEmail(String email);

  Future<Either<String, String>> resetPassword(AuthResetPasswordParams params);

  Future<Either<String, String>> sendResetPasswordEmail(String email);

  Future<AuthProfile?> getProfileIfUserIsAuthenticated();
}
