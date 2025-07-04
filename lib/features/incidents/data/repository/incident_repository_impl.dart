import "package:ciudadano/features/incidents/data/source/incident_api_service.dart";
import "package:ciudadano/features/incidents/domain/entities/create_incident.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentApiService _incidentApiService;

  const IncidentRepositoryImpl(this._incidentApiService);

  @override
  Future<Either<String, Incident>> createIncident(CreateIncident incident) {
    return _incidentApiService.createIncident(incident);
  }

  @override
  Future<Either<String, List<Incident>>> getNearbyIncidents(LatLng location) {
    return _incidentApiService.getNearbyIncidents(location);
  }
}
