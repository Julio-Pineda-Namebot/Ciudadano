import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:rxdart/rxdart.dart";

class IncidentInMemoryStreamSource with _NearbyIncidentsInMemoryStreamSource {
  IncidentInMemoryStreamSource();
}

mixin _NearbyIncidentsInMemoryStreamSource {
  final _nearbyIncidentsubjects = BehaviorSubject<List<Incident>?>.seeded(null);
  Stream<List<Incident>> get nearbyIncidentsStream =>
      _nearbyIncidentsubjects.stream
          .where((incidents) => incidents != null)
          .cast<List<Incident>>();

  List<Incident>? get currentNearbyIncidents =>
      _nearbyIncidentsubjects.hasError ? null : _nearbyIncidentsubjects.value;

  void updateNearbyIncidents(List<Incident> incidents) {
    _nearbyIncidentsubjects.add(incidents);
  }

  void throwErrorNearbyIncidents(String error) {
    _nearbyIncidentsubjects.addError(error);
  }

  void clearNearbyIncidents() {
    _nearbyIncidentsubjects.add(null);
  }

  void addNearbyIncident(Incident incident) {
    final currentIncidents = _nearbyIncidentsubjects.valueOrNull;
    if (currentIncidents != null) {
      _nearbyIncidentsubjects.add([...currentIncidents, incident]);
    }
  }

  // final _nearbyIncidentsMappedSubjects =
  //     <LatLng, BehaviorSubject<List<Incident>?>>{};
  // BehaviorSubject<List<Incident>?> _getSubjectForLocation(LatLng location) {
  //   if (!_nearbyIncidentsMappedSubjects.containsKey(location)) {
  //     _nearbyIncidentsMappedSubjects[location] =
  //         BehaviorSubject<List<Incident>?>.seeded(null);
  //   }
  //   return _nearbyIncidentsMappedSubjects[location]
  //       as BehaviorSubject<List<Incident>?>;
  // }

  // void updateNearbyIncidents(List<Incident> incidents, LatLng location) {
  //   final subject = _getSubjectForLocation(location);
  //   subject.add(incidents);
  // }

  // Stream<List<Incident>> getNearbyIncidentsStream(LatLng location) {
  //   final subject = _getSubjectForLocation(location);
  //   return subject.stream
  //       .where((incidents) => incidents != null)
  //       .cast<List<Incident>>();
  // }

  // List<Incident>? getCurrentNearbyIncidents(LatLng location) {
  //   final subject = _getSubjectForLocation(location);
  //   if (subject.hasError) {
  //     return null;
  //   }
  //   return subject.value;
  // }

  // void throwErrorNearbyIncidents(LatLng location, String error) {
  //   final subject = _getSubjectForLocation(location);
  //   subject.addError(error);
  // }

  // void disposeNearbyIncidents(LatLng location) {
  //   final subject = _getSubjectForLocation(location);
  //   subject.close();
  //   _nearbyIncidentsMappedSubjects.remove(location);
  // }

  // void addNearbyIncident(
  //   Incident incident,
  // ) {
  //   final subjects = _nearbyIncidentsMappedSubjects.values;
  //   for (final subject in subjects) {
  //     final currentIncidents = subject.valueOrNull;
  //     if (currentIncidents != null) {
  //       subject.add([...currentIncidents, incidents]);
  //     }
  //   }
  // }
}
