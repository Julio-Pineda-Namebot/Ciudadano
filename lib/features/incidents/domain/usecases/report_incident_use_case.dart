import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/params/report_incident_param.dart";
import "package:ciudadano/features/incidents/domain/repositories/incident_repository.dart";
import "package:dartz/dartz.dart";

class ReportIncidentUseCase {
  final IncidentRepository _incidentRepository;

  ReportIncidentUseCase(this._incidentRepository);

  Future<Either<String, Incident>> call(
    ReportIncidentParam reportIncidentParam,
  ) {
    return _incidentRepository.reportIncident(reportIncidentParam);
  }
}
