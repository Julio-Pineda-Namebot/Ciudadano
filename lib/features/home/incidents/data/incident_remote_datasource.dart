import "dart:io";

import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/home/incidents/data/models/incident_model.dart";
import "package:ciudadano/service_locator.dart";
import "package:dio/dio.dart";
import "package:latlong2/latlong.dart";

class IncidentRemoteDatasource {
  final DioClient _dio = sl<DioClient>();

  Future<List<IncidentModel>> getIncidents() async {
    try {
      final response = await _dio.get("/incidents/");

      if (response.statusCode == 200) {
        final data = response.data;
        final incidentList = data["data"] as List;
        return incidentList.map((e) => IncidentModel.fromJson(e)).toList();
      } else {
        throw Exception("Error inesperado. Código: ${response.statusCode}");
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data["message"] ?? "No se pudieron cargar los incidentes";
      throw Exception(msg);
    }
  }

  Future<List<IncidentModel>> getNearbyIncidents(LatLng location) async {
    try {
      final response = await _dio.get(
        "/incidents/map/${location.latitude}/${location.longitude}",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final incidentList = data["data"] as List;
        return incidentList.map((e) => IncidentModel.fromJson(e)).toList();
      } else {
        throw Exception("Error inesperado. Código: ${response.statusCode}");
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data["message"] ??
          "No se pudieron cargar los incidentes cercanos";
      throw Exception(msg);
    }
  }

  Future<IncidentModel> createIncident({
    required String description,
    required String incidentType,
    required File image,
    required LatLng location,
  }) async {
    try {
      final formData = FormData.fromMap({
        "description": description,
        "incident_type": incidentType,
        "image": await MultipartFile.fromFile(image.path),
        "location_lat": location.latitude,
        "location_lon": location.longitude,
      });

      final response = await _dio.post("/incidents/", data: formData);

      if (response.statusCode == 201) {
        return IncidentModel.fromJson(response.data["data"]);
      } else {
        throw Exception("Error inesperado. Código: ${response.statusCode}");
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data["message"] ?? "No se pudo crear el incidente";
      throw Exception(msg);
    }
  }
}
