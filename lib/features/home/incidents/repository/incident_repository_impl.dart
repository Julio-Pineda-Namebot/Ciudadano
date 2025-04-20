import 'package:ciudadano/features/home/incidents/data/entities/incident.dart';
import 'package:ciudadano/features/home/incidents/data/incident_remote_datasource.dart';
import 'package:ciudadano/features/home/incidents/repository/incident_repository.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDatasource remoteDatasource;

  IncidentRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Incident>> getIncidents() async {
    return await remoteDatasource.getIncidents();
  }
}
