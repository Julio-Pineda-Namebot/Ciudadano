import "package:ciudadano/core/api/dio_client.dart";
import "package:ciudadano/features/incidents/data/models/incident_model.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
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
      return Left(e.message ?? "Error al obtener incidentes cercanos");
    }
  }
}
