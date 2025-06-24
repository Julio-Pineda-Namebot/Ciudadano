import "dart:io";

import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:ciudadano/features/incidents/data/source/incident_api_service.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentApiService _incidentApiService;

  const IncidentRepositoryImpl(this._incidentApiService);

  @override
  Future<Either<String, Incident>> createIncident({
    required String description,
    required String incidentType,
    required File image,
    required LatLng location,
  }) {
    return _incidentApiService.createIncident(
      description: description,
      incidentType: incidentType,
      image: image,
      location: location,
    );
  }

  @override
  Future<Either<String, List<Incident>>> getNearbyIncidents(LatLng location) {
    return _incidentApiService.getNearbyIncidents(location);
  }
}
