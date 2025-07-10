import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/incidents/domain/entities/create_incident.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:dartz/dartz.dart";

class CreateIncidentUseCase
    implements UseCase<Either<String, Incident>, CreateIncident> {
  final IncidentRepository _incidentRepository;

  const CreateIncidentUseCase(this._incidentRepository);

  @override
  Future<Either<String, Incident>> call(CreateIncident params) async {
    return _incidentRepository.createIncident(params);
  }
}
