import 'package:ciudadano/features/home/incidents/data/entities/incident.dart';

abstract class IncidentRepository {
  Future<List<Incident>> getIncidents();
}
