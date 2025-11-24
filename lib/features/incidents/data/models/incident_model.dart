import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:latlong2/latlong.dart";

class IncidentModel extends Incident {
  const IncidentModel({
    required super.id,
    required super.type,
    required super.userId,
    required super.description,
    required super.location,
    required super.multimediaUrl,
    required super.createdAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    final typeString = json["incidentType"] as String;

    return IncidentModel(
      id: json["id"] as String,
      type: switch (typeString) {
        "robo" => IncidentType.steal,
        "accidente" => IncidentType.accident,
        "vandalismo" => IncidentType.vandalism,
        _ => throw Exception("Tipo de incidente desconocido: $typeString"),
      },
      userId: json["userId"] as String,
      description: json["description"] as String,
      location: LatLng(
        (json["geolocation"]["latitude"] as num).toDouble(),
        (json["geolocation"]["longitude"] as num).toDouble(),
      ),
      multimediaUrl: json["multimediaUrl"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
    );
  }
}
