import "package:ciudadano/features/incidents/domain/entities/create_incident.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

abstract class IncidentRepository {
  Future<Either<String, List<Incident>>> getNearbyIncidents(LatLng location);

  Future<Either<String, Incident>> createIncident(CreateIncident incident);
}
