import "dart:io";

import "package:ciudadano/features/home/incidents/data/entities/incident.dart";
import "package:ciudadano/features/home/incidents/data/incident_remote_datasource.dart";
import "package:ciudadano/features/home/incidents/repository/incident_repository.dart";
import "package:latlong2/latlong.dart";

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDatasource remoteDatasource;

  IncidentRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Incident>> getNearbyIncidents(LatLng location) async {
    return await remoteDatasource.getNearbyIncidents(location);
  }

  @override
  Future<Incident> createIncident({
    required String description,
    required String incidentType,
    required File image,
    required LatLng location,
  }) {
    return remoteDatasource.createIncident(
      description: description,
      incidentType: incidentType,
      image: image,
      location: location,
    );
  }
}
