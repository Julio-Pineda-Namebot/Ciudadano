import "dart:io";

import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:equatable/equatable.dart";
import "package:latlong2/latlong.dart";

class ReportIncidentParam extends Equatable {
  final IncidentType incidentType;
  final String description;
  final File image;
  final LatLng location;

  const ReportIncidentParam({
    required this.incidentType,
    required this.description,
    required this.image,
    required this.location,
  });

  @override
  List<Object?> get props => [incidentType, description, image, location];
}
