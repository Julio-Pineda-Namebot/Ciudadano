import "dart:io";

import "package:ciudadano/features/home/incidents/data/entities/incident.dart";
import "package:latlong2/latlong.dart";

abstract class IncidentRepository {
  Future<List<Incident>> getNearbyIncidents(LatLng location);

  Future<Incident> createIncident({
    required String description,
    required String incidentType,
    required File image,
    required LatLng location,
  });
}
