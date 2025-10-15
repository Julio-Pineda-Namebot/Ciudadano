import "package:dio/dio.dart";
import "../../../../core/network/dio_cliente.dart";
import "../../../../service_locator.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

abstract class NotificationApiSource {
  Future<bool> registerPushToken(String token, String platform);
  Future<bool> unregisterPushToken(String token);
}

class NotificationApiSourceImpl implements NotificationApiSource {
  final DioClient _dio = sl<DioClient>();
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();

  @override
  Future<bool> registerPushToken(String token, String platform) async {
    try {
      final authToken = await _secureStorage.read(key: "auth_token");

      if (authToken == null) {
        throw Exception("No auth token found");
      }

      final response = await _dio.post(
        "/push-notifications/register-token",
        data: {"token": token, "platform": platform},
        options: Options(headers: {"Authorization": "Bearer $authToken"}),
      );

      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      throw Exception("Failed to register push token: $e");
    }
  }

  @override
  Future<bool> unregisterPushToken(String token) async {
    try {
      final authToken = await _secureStorage.read(key: "auth_token");

      if (authToken == null) {
        throw Exception("No auth token found");
      }

      final response = await _dio.post(
        "/push-notifications/unregister-token",
        data: {"token": token},
        options: Options(headers: {"Authorization": "Bearer $authToken"}),
      );

      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      throw Exception("Failed to unregister push token: $e");
    }
  }
}
