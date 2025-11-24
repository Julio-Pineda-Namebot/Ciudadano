import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/repositories/incident_repository.dart";
import "package:latlong2/latlong.dart";

class WatchNearbyIncidentsUseCase {
  final IncidentRepository repository;

  WatchNearbyIncidentsUseCase(this.repository);

  Stream<List<Incident>> call(LatLng location) {
    return repository.watchNearbyIncidents(location);
  }
}
