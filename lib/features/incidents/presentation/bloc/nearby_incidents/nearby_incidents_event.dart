part of "nearby_incidents_bloc.dart";

abstract class NearbyIncidentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNearbyIncidents extends NearbyIncidentsEvent {
  final LatLng userLocation;

  LoadNearbyIncidents(this.userLocation);

  @override
  List<Object?> get props => [userLocation];
}

class RefreshNearbyIncidents extends NearbyIncidentsEvent {}

class _StreamUpdateNearbyIncidents extends NearbyIncidentsEvent {
  final List<Incident> incidents;
  final LatLng userLocation;

  _StreamUpdateNearbyIncidents(this.incidents, this.userLocation);
  @override
  List<Object?> get props => [incidents, userLocation];
}

class NearbyIncidentReportedEvent extends NearbyIncidentsEvent {
  final Incident incident;

  NearbyIncidentReportedEvent(this.incident);

  @override
  List<Object?> get props => [incident];
}
