import "package:ciudadano/core/api/dio_client.dart";
import "package:ciudadano/features/incidents/data/models/incident_model.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/params/report_incident_param.dart";
import "package:dartz/dartz.dart";
import "package:dio/dio.dart";
import "package:latlong2/latlong.dart";

class IncidentApiSource {
  final DioClient _dio;

  const IncidentApiSource(this._dio);

  Future<Either<String, List<Incident>>> getNearbyIncidents(
    LatLng location,
  ) async {
    try {
      final response = await _dio.get(
        "/incidents/nearby",
        queryParameters: {"lat": location.latitude, "lon": location.longitude},
      );

      final incidentListJson = response.data["data"] as List<dynamic>;

      return Right(
        incidentListJson
            .map(
              (incident) =>
                  IncidentModel.fromJson(incident as Map<String, dynamic>),
            )
            .toList(),
      );
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "Error al obtener incidentes cercanos",
      );
    }
  }

  Future<Either<String, Incident>> reportIncident(
    ReportIncidentParam reportIncidentParam,
  ) async {
    try {
      final response = await _dio.post(
        "/incidents/report",
        data: FormData.fromMap({
          "description": reportIncidentParam.description,
          "incident_type": reportIncidentParam.incidentType.value.toLowerCase(),
          "multimedia": await MultipartFile.fromFile(
            reportIncidentParam.image.path,
            filename: reportIncidentParam.image.path.split("/").last,
          ),
          "latitude": reportIncidentParam.location.latitude,
          "longitude": reportIncidentParam.location.longitude,
        }),
      );

      return Right(IncidentModel.fromJson(response.data["data"]));
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "Error al reportar el incidente",
      );
    }
  }
}
