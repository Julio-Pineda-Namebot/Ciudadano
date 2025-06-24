import "dart:io";

import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/incidents/data/models/incident_model.dart";
import "package:ciudadano/service_locator.dart";
import "package:dartz/dartz.dart";
import "package:dio/dio.dart";
import "package:latlong2/latlong.dart";

class IncidentApiService {
  final DioClient _dio = sl<DioClient>();

  Future<Either<String, List<IncidentModel>>> getIncidents() async {
    try {
      final response = await _dio.get("/incidents/");

      final incidentList = response.data["data"] as List;
      return Right(incidentList.map((e) => IncidentModel.fromJson(e)).toList());
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "No se pudieron cargar los incidentes",
      );
    }
  }

  Future<Either<String, List<IncidentModel>>> getNearbyIncidents(
    LatLng location,
  ) async {
    try {
      final response = await _dio.get(
        "/incidents/map/${location.latitude}/${location.longitude}",
      );

      final incidentList = response.data["data"] as List;
      return Right(
        incidentList
            .map<IncidentModel>((e) => IncidentModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      final msg =
          e.response?.data["message"] ??
          "No se pudieron cargar los incidentes cercanos";
      throw Exception(msg);
    }
  }

  Future<Either<String, IncidentModel>> createIncident({
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

      return Right(IncidentModel.fromJson(response.data["data"]));
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "No se pudo crear el incidente",
      );
    }
  }
}
