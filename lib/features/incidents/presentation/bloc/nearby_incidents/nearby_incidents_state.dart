part of "nearby_incidents_bloc.dart";

abstract class NearbyIncidentsState extends Equatable {
  const NearbyIncidentsState();

  @override
  List<Object?> get props => [];
}

class NearbyIncidentsInitial extends NearbyIncidentsState {}

class NearbyIncidentsLoading extends NearbyIncidentsState {}

class NearbyIncidentsLoaded extends NearbyIncidentsState {
  final LatLng location;
  final List<Incident> incidents;

  const NearbyIncidentsLoaded(this.location, this.incidents);

  @override
  List<Object?> get props => [location, incidents];
}

class NearbyIncidentsError extends NearbyIncidentsState {
  final String message;
  const NearbyIncidentsError(this.message);

  @override
  List<Object?> get props => [message];
}
