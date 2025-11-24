import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

abstract class IncidentRepository {
  Future<Either<String, List<Incident>>> getNearbyIncidents(LatLng location);
  Stream<List<Incident>> watchNearbyIncidents(LatLng location);
}
