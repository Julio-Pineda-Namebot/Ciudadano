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
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json["id"],
      incidentType: json["incidentType"],
      description: json["description"],
      location: LatLng(
        json["geolocation"]["latitude"].toDouble(),
        json["geolocation"]["longitude"].toDouble(),
      ),
      imageUrl: json["multimediaUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
