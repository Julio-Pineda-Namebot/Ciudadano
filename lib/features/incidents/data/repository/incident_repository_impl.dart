import "package:ciudadano/features/incidents/data/source/incident_api_service.dart";
import "package:ciudadano/features/incidents/data/source/incident_in_memory_source.dart";
import "package:ciudadano/features/incidents/domain/entities/report_incident.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentApiService _incidentApiService;
  final IncidentInMemorySource _incidentInMemorySource;

  const IncidentRepositoryImpl(
    this._incidentApiService,
    this._incidentInMemorySource,
  );

  @override
  Future<Either<String, Incident>> reportIncident(
    ReportIncident incident,
  ) async {
    final result = await _incidentApiService.reportIncident(incident);

    if (result.isRight()) {
      result.fold(
        (l) => {},
        (reportedIncident) =>
            _incidentInMemorySource.addNearbyIncident(reportedIncident),
      );
    }

    return result;
  }

  @override
  Future<Either<String, List<Incident>>> getNearbyIncidents(
    LatLng location,
  ) async {
    if (_incidentInMemorySource.currentNearbyIncidents.isNotEmpty) {
      return Right(_incidentInMemorySource.currentNearbyIncidents);
    }

    final result = await _incidentApiService.getNearbyIncidents(location);

    if (result.isRight()) {
      result.fold(
        (l) => {},
        (result) => _incidentInMemorySource.setNearbyIncidents(result),
      );
    }

    return result;
  }

  @override
  Stream<List<Incident>> watchNearbyIncidents() {
    return _incidentInMemorySource.incidentsStream;
  }
}
