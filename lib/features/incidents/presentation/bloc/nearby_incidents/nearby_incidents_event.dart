part of "nearby_incidents_bloc.dart";

abstract class NearbyIncidentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNearbyIncidents extends NearbyIncidentsEvent {}

class NearbyIncidentReportedEvent extends NearbyIncidentsEvent {
  final Incident incident;

  NearbyIncidentReportedEvent(this.incident);

  @override
  List<Object?> get props => [incident];
}
