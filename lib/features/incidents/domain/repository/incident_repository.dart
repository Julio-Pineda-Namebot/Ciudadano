import "dart:io";

import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

abstract class IncidentRepository {
  Future<Either<String, List<Incident>>> getNearbyIncidents(LatLng location);

  Future<Either<String, Incident>> createIncident({
    required String description,
    required String incidentType,
    required File image,
    required LatLng location,
  });
}
