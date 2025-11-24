import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:latlong2/latlong.dart";
import "package:rxdart/rxdart.dart";

class IncidentInMemoryStreamSource with _NearbyIncidentsInMemoryStreamSource {
  IncidentInMemoryStreamSource();
}

mixin _NearbyIncidentsInMemoryStreamSource {
  final _nearbyIncidentsMappedSubjects =
      <LatLng, BehaviorSubject<List<Incident>?>>{};
  // final _nearbyIncidentsSubject = BehaviorSubject<List<Incident>?>.seeded(null);
  BehaviorSubject<List<Incident>?> _getSubjectForLocation(LatLng location) {
    if (!_nearbyIncidentsMappedSubjects.containsKey(location)) {
      _nearbyIncidentsMappedSubjects[location] =
          BehaviorSubject<List<Incident>?>.seeded(null);
    }
    return _nearbyIncidentsMappedSubjects[location]
        as BehaviorSubject<List<Incident>?>;
  }

  void updateNearbyIncidents(List<Incident> incidents, LatLng location) {
    final subject = _getSubjectForLocation(location);
    subject.add(incidents);
  }

  Stream<List<Incident>> getNearbyIncidentsStream(LatLng location) {
    final subject = _getSubjectForLocation(location);
    return subject.stream
        .where((incidents) => incidents != null)
        .cast<List<Incident>>();
  }

  List<Incident>? getCurrentNearbyIncidents(LatLng location) {
    final subject = _getSubjectForLocation(location);
    if (subject.hasError) {
      return null;
    }
    return subject.value;
  }

  void throwErrorNearbyIncidents(LatLng location, String error) {
    final subject = _getSubjectForLocation(location);
    subject.addError(error);
  }

  void disposeNearbyIncidents(LatLng location) {
    final subject = _getSubjectForLocation(location);
    subject.close();
    _nearbyIncidentsMappedSubjects.remove(location);
  }
}
