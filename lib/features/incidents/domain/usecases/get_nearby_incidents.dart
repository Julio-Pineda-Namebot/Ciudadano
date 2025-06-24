import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:dartz/dartz.dart";
import "package:latlong2/latlong.dart";

class GetNearbyIncidents
    implements UserCase<Either<String, List<Incident>>, LatLng> {
  final IncidentRepository _incidentRepository;

  const GetNearbyIncidents(this._incidentRepository);

  @override
  Future<Either<String, List<Incident>>> call(LatLng location) {
    return _incidentRepository.getNearbyIncidents(location);
  }
}
