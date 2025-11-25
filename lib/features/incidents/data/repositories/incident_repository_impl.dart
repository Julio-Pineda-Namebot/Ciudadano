import "package:ciudadano/features/incidents/data/sources/incident_api_source.dart";
import "package:ciudadano/features/incidents/data/sources/incident_in_memory_stream_source.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/params/report_incident_param.dart";
import "package:ciudadano/features/incidents/domain/repositories/incident_repository.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentApiSource _apiSource;
  final IncidentInMemoryStreamSource _inMemoryStreamSource;

  const IncidentRepositoryImpl(this._apiSource, this._inMemoryStreamSource);

  @override
  Future<Either<String, List<Incident>>> getNearbyIncidents(
    LatLng location,
  ) async {
    return _apiSource
        .getNearbyIncidents(location)
        .then(
          (either) => either.fold(
            (message) {
              _inMemoryStreamSource.throwErrorNearbyIncidents(message);
              return Left(message);
            },
            (incidents) {
              _inMemoryStreamSource.updateNearbyIncidents(incidents);
              return Right(incidents);
            },
          ),
        );
  }

  @override
  Stream<List<Incident>> watchNearbyIncidents(LatLng location) {
    if (_inMemoryStreamSource.currentNearbyIncidents == null) {
      getNearbyIncidents(location);
    }

    return _inMemoryStreamSource.nearbyIncidentsStream;
  }

  @override
  Future<Either<String, Incident>> reportIncident(
    ReportIncidentParam reportIncidentParam,
  ) {
    return _apiSource
        .reportIncident(reportIncidentParam)
        .then(
          (either) => either.fold((message) => Left(message), (incident) {
            _inMemoryStreamSource.addNearbyIncident(incident);
            return Right(incident);
          }),
        );
  }
}
