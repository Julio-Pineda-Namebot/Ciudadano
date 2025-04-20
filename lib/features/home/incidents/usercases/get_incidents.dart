import 'package:ciudadano/features/home/incidents/data/entities/incident.dart';
import 'package:ciudadano/features/home/incidents/repository/incident_repository.dart';

class GetIncidents {
  final IncidentRepository repository;

  GetIncidents(this.repository);

  Future<List<Incident>> call() async {
    return await repository.getIncidents();
  }
}