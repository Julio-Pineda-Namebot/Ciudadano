import 'package:ciudadano/features/home/incidents/data/entities/incident.dart';

class IncidentModel extends Incident {
  const IncidentModel({
    required super.id,
    required super.incidentType,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.imageUrl,
    required super.createdAt,
    required super.happenedAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'],
      incidentType: json['incident_type'],
      description: json['description'],
      latitude: json['location_lat'].toDouble(),
      longitude: json['location_lon'].toDouble(),
      imageUrl: json['multimedia'],
      createdAt: DateTime.parse(json['createad_at']),
      happenedAt: DateTime.parse(json['happend_at']),
    );
  }
}
