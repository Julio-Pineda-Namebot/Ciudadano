import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:latlong2/latlong.dart";

class IncidentModel extends Incident {
  const IncidentModel({
    required super.id,
    required super.incidentType,
    required super.description,
    required super.location,
    required super.imageUrl,
    required super.createdAt,
    required super.happenedAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json["id"],
      incidentType: json["incident_type"],
      description: json["description"],
      location: LatLng(
        json["location_lat"].toDouble(),
        json["location_lon"].toDouble(),
      ),
      imageUrl: json["multimedia"],
      createdAt: DateTime.parse(json["created_at"]),
      happenedAt: DateTime.parse(json["happend_at"]),
    );
  }
}
