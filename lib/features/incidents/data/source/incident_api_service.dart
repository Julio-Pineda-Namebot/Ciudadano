import "dart:io";

import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/incidents/data/models/incident_model.dart";
import "package:ciudadano/features/incidents/domain/entities/create_incident.dart";
import "package:ciudadano/service_locator.dart";
import "package:dartz/dartz.dart";
import "package:dio/dio.dart";
import "package:latlong2/latlong.dart";

class IncidentApiService {
  final DioClient _dio = sl<DioClient>();

  Future<Either<String, List<IncidentModel>>> getIncidents() async {
    try {
      final response = await _dio.get("/report/");

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
        "/incidents/nearby?lat=${location.latitude}&lon=${location.longitude}",
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

  Future<Either<String, IncidentModel>> createIncident(
    CreateIncident incident,
  ) async {
    try {
      final formData = await incident.toFormData();

      final response = await _dio.post(
        "/incidents/report",
        data: formData,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "multipart/form-data"},
        ),
      );

      return Right(IncidentModel.fromJson(response.data["data"]));
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "No se pudo crear el incidente",
      );
    }
  }
}
