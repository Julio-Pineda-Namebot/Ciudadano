import "package:ciudadano/features/home/incidents/data/entities/incident.dart";
import "package:ciudadano/features/home/incidents/repository/incident_repository.dart";
import "package:latlong2/latlong.dart";

class GetNearbyIncidents {
  final IncidentRepository repository;

  GetNearbyIncidents(this.repository);

  Future<List<Incident>> call(LatLng location) async {
    return await repository.getNearbyIncidents(location);
  }
}
