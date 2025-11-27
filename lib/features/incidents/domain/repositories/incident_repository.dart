import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/params/report_incident_param.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

abstract class IncidentRepository {
  Future<Either<String, List<Incident>>> getNearbyIncidents(LatLng location);
  Stream<List<Incident>> watchNearbyIncidents(LatLng location);
  Stream<Incident> watchIncidentReported();

  Future<Either<String, Incident>> reportIncident(
    ReportIncidentParam reportIncidentParam,
  );
}
