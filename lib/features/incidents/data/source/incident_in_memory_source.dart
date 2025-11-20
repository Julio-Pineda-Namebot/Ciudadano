import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:rxdart/rxdart.dart";

class IncidentInMemorySource {
  final _nearbyIncidentsSubject = BehaviorSubject<List<Incident>>.seeded([]);

  Stream<List<Incident>> get incidentsStream => _nearbyIncidentsSubject.stream;
  List<Incident> get currentNearbyIncidents => _nearbyIncidentsSubject.value;

  void setNearbyIncidents(List<Incident> incidents) {
    _nearbyIncidentsSubject.add(incidents);
  }

  void addNearbyIncident(Incident incident) {
    final updatedIncidents = List<Incident>.from(currentNearbyIncidents)
      ..add(incident);
    _nearbyIncidentsSubject.add(updatedIncidents);
  }

  void dispose() {
    _nearbyIncidentsSubject.close();
  }
}
