import "package:dio/dio.dart";
import "../../../../core/network/dio_cliente.dart";
import "../../../../service_locator.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "../models/alert_model.dart";

abstract class AlertRemoteDataSource {
  Future<AlertModel> createAlert({
    required double latitude,
    required double longitude,
    String? address,
    String? message,
  });

  Future<bool> deactivateAlert(String alertId);

  Future<List<AlertModel>> getUserAlerts();

  Future<AlertModel?> getActiveAlert();
}

class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {
  final DioClient _dio = sl<DioClient>();
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();

  @override
  Future<AlertModel> createAlert({
    required double latitude,
    required double longitude,
    String? address,
    String? message,
  }) async {
    try {
      final response = await _dio.post(
        "/alerts/dispatch",
        data: {"latitude": latitude, "longitude": longitude},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AlertModel.fromJson(response.data["data"] ?? response.data);
      } else {
        throw Exception("Failed to create alert: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error creating alert: $e");
    }
  }

  @override
  Future<bool> deactivateAlert(String alertId) async {
    try {
      final authToken = await _secureStorage.read(key: "auth_token");

      if (authToken == null) {
        throw Exception("No auth token found");
      }

      final response = await _dio.put(
        "/alerts/$alertId",
        data: {"status": "inactive"},
        options: Options(headers: {"Authorization": "Bearer $authToken"}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Error deactivating alert: $e");
    }
  }

  @override
  Future<List<AlertModel>> getUserAlerts() async {
    try {
      final authToken = await _secureStorage.read(key: "auth_token");

      if (authToken == null) {
        throw Exception("No auth token found");
      }

      final response = await _dio.get(
        "/alerts",
        options: Options(headers: {"Authorization": "Bearer $authToken"}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> alertsJson = response.data["data"] ?? [];
        return alertsJson.map((json) => AlertModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to get alerts: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error getting alerts: $e");
    }
  }

  @override
  Future<AlertModel?> getActiveAlert() async {
    try {
      final authToken = await _secureStorage.read(key: "auth_token");

      if (authToken == null) {
        throw Exception("No auth token found");
      }

      final response = await _dio.get(
        "/api/alerts/active",
        options: Options(headers: {"Authorization": "Bearer $authToken"}),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        return AlertModel.fromJson(response.data["data"]);
      }

      return null; // No hay alerta activa
    } catch (e) {
      // Si no hay alerta activa, retornamos null en lugar de lanzar excepción
      return null;
    }
  }
}
