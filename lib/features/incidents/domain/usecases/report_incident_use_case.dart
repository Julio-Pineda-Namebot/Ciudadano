import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/incidents/domain/entities/report_incident.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:dartz/dartz.dart";

class ReportIncidentUseCase
    implements UseCase<Either<String, Incident>, ReportIncident> {
  final IncidentRepository _incidentRepository;

  const ReportIncidentUseCase(this._incidentRepository);

  @override
  Future<Either<String, Incident>> call(ReportIncident params) async {
    return _incidentRepository.reportIncident(params);
  }
}
