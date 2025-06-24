import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:dio/dio.dart";

class AuthRemoteDatasource {
  final DioClient _dio = sl<DioClient>();
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data["data"]?["token"];

        if (data != null &&
            data["data"] != null &&
            data["data"]["token"] != null) {
          if (token != null) {
            await secureStorage.write(key: "auth_token", value: token);
          }
          return null;
        } else {
          return data["message"] ?? "Respuesta inesperada del servidor.";
        }
      } else {
        return "Error inesperado con código ${response.statusCode}";
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        return responseData["message"] ?? "Error al iniciar sesión.";
      } else {
        return "Credenciales Incorrectas.";
      }
    }
  }

  Future<String?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dni,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "dni": dni,
        },
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return response.data["message"] ?? "Error al registrar";
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        return responseData["message"] ?? "Error al registrar usuario";
      } else {
        return "Error al registrar usuario.";
      }
    }
  }

  Future<String?> verifyEmail(String email, String code) async {
    try {
      final response = await _dio.post(
        "/auth/verify-email",
        data: {"email": email, "code": code},
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return response.data["message"] ?? "Error al verificar el correo";
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        return responseData["message"] ?? "Error al verificar el correo";
      } else {
        return "Error al verificar el correo.";
      }
    }
  }

  Future<String?> resendVerificationCode(String email) async {
    try {
      final response = await _dio.post(
        "/auth/resend-email-verification-code",
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return response.data["message"] ?? "Error al reenviar código";
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        return responseData["message"] ?? "Error al reenviar código";
      } else {
        return "Error al reenviar código.";
      }
    }
  }

  Future<String?> sendRecoveryEmail(String email) async {
    try {
      final response = await _dio.post(
        "/auth/send-reset-password-email",
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return response.data["message"] ??
            "Error al enviar correo de recuperación.";
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        return responseData["message"] ??
            "Error al enviar correo de recuperación.";
      } else {
        return "Error al enviar correo de recuperación.";
      }
    }
  }

  Future<String?> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await _dio.put(
        "/auth/reset-password",
        data: {"email": email, "code": code, "password": newPassword},
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return response.data["message"] ??
            "Error al restablecer la contraseña.";
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        return responseData["message"] ?? "Error al restablecer la contraseña.";
      } else {
        return "Error al restablecer la contraseña.";
      }
    }
  }
}
