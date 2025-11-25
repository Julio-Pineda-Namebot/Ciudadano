import "package:equatable/equatable.dart";
import "package:latlong2/latlong.dart";

enum IncidentType {
  steal("Robo"),
  accident("Accidente"),
  vandalism("Vandalismo");

  final String value;
  const IncidentType(this.value);
}

class Incident extends Equatable {
  final String id;
  final IncidentType type;
  final String userId;
  final String description;
  final LatLng location;
  final String multimediaUrl;
  final DateTime createdAt;

  const Incident({
    required this.id,
    required this.type,
    required this.userId,
    required this.description,
    required this.location,
    required this.multimediaUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    userId,
    description,
    location,
    multimediaUrl,
    createdAt,
  ];
}
