import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/repositories/incident_repository.dart";

class WatchIncidentReportedUseCase {
  final IncidentRepository _repository;

  WatchIncidentReportedUseCase(this._repository);

  Stream<Incident> call() {
    return _repository.watchIncidentReported();
  }
}
