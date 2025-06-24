import "package:equatable/equatable.dart";
import "package:latlong2/latlong.dart";

abstract class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCurrentLocation extends MapEvent {}

class LoadIncidents extends MapEvent {}

class UpdateLocation extends MapEvent {
  final LatLng location;
  UpdateLocation(this.location);

  @override
  List<Object?> get props => [location];
}
