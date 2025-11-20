import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";

class WatchNearbyIncidentsUseCase
    implements UseCase<Stream<List<Incident>>, void> {
  final IncidentRepository _incidentRepository;

  const WatchNearbyIncidentsUseCase(this._incidentRepository);

  @override
  Future<Stream<List<Incident>>> call(void params) {
    return Future.value(_incidentRepository.watchNearbyIncidents());
  }
}
