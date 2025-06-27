import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";

class ListenIncidentsReportedUseCase
    implements UseCase<void, Function(Incident)> {
  final SocketRepository _socketRepository;

  const ListenIncidentsReportedUseCase(this._socketRepository);

  @override
  Future<void> call(Function(Incident) onIncidentReported) async {
    _socketRepository.listenIncidentsReported(onIncidentReported);
  }
}
