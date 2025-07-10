import "package:latlong2/latlong.dart";

abstract class Incident {
  final String id;
  final String incidentType;
  final String description;
  final LatLng location;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime happenedAt;

  const Incident({
    required this.id,
    required this.incidentType,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.createdAt,
    required this.happenedAt,
  });
}
