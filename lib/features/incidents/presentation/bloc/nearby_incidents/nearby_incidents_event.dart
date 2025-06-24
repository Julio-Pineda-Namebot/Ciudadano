part of "nearby_incidents_bloc.dart";

abstract class NearbyIncidentsMapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNearbyIncidents extends NearbyIncidentsMapEvent {}

class UpdateLocation extends NearbyIncidentsMapEvent {
  final LatLng location;
  UpdateLocation(this.location);

  @override
  List<Object?> get props => [location];
}
