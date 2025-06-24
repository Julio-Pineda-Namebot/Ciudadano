import "package:ciudadano/features/home/incidents/data/entities/incident.dart";
import "package:equatable/equatable.dart";
import "package:latlong2/latlong.dart";

abstract class MapState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final LatLng location;
  final List<Incident> incidents;

  MapLoaded(this.location, this.incidents);

  @override
  List<Object?> get props => [location, incidents];
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
  @override
  List<Object?> get props => [message];
}
