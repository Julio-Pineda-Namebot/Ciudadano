import "package:ciudadano/core/api/dio_client.dart";
import "package:ciudadano/features/auth/data/models/auth_profile_model.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/domain/params/auth_login_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_register_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_reset_password_params.dart";
import "package:ciudadano/features/auth/domain/params/auth_verify_email_params.dart";
import "package:dartz/dartz.dart";
import "package:dio/dio.dart";

class AuthApiSource {
  final DioClient _dio;

  const AuthApiSource(this._dio);

  Future<Either<String, String>> login(AuthLoginParams params) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": params.email, "password": params.password},
      );

      final token = response.data["data"]["token"] as String;

      return Right(token);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Error al iniciar sesión");
    }
  }

  Future<Either<String, String>> register(AuthRegisterParams params) async {
    try {
      final response = await _dio.post(
        "/auth/register",
        data: {
          "email": params.email,
          "password": params.password,
          "firstName": params.firstName,
          "lastName": params.lastName,
          "phone": params.phone,
          "dni": params.dni,
        },
      );

      return Right(response.data["message"] as String);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Error al registrar usuario");
    }
  }

  Future<Either<String, String>> verifyEmail(
    AuthVerifyEmailParams params,
  ) async {
    try {
      final response = await _dio.post(
        "/auth/verify-email",
        data: {"email": params.email, "code": params.code},
      );

      return Right(response.data["message"] as String);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ??
            "Error al verificar el correo electrónico",
      );
    }
  }

  Future<Either<String, String>> resendVerificationEmail(String email) async {
    try {
      final response = await _dio.post(
        "/auth/resend-email-verification-code",
        data: {"email": email},
      );

      return Right(response.data["message"] as String);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ??
            "Error al reenviar el correo de verificación",
      );
    }
  }

  Future<Either<String, String>> resetPassword(
    AuthResetPasswordParams params,
  ) async {
    try {
      final response = await _dio.post(
        "/auth/reset-password",
        data: {
          "email": params.email,
          "code": params.code,
          "password": params.password,
        },
      );

      return Right(response.data["message"] as String);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "Error al restablecer la contraseña",
      );
    }
  }

  Future<Either<String, String>> sendResetPasswordEmail(String email) async {
    try {
      final response = await _dio.post(
        "/auth/send-password-reset-code-email",
        data: {"email": email},
      );

      return Right(response.data["message"] as String);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ??
            "Error al enviar el correo de restablecimiento de contraseña",
      );
    }
  }

  Future<Either<String, AuthProfile>> getProfile() async {
    try {
      final response = await _dio.get("/auth/profile");

      return Right(AuthProfileModel.fromJson(response.data["data"]));
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Error al obtener el perfil");
    }
  }
}
