import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/repositories/incident_repository.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

class GetNearbyIncidentsUseCase {
  final IncidentRepository repository;

  GetNearbyIncidentsUseCase(this.repository);

  Future<Either<String, List<Incident>>> call(LatLng location) {
    return repository.getNearbyIncidents(location);
  }
}
