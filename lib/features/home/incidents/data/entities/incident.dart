import 'package:equatable/equatable.dart';

class Incident extends Equatable {
  final String id;
  final String incidentType;
  final String description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime happenedAt;

  const Incident({
    required this.id,
    required this.incidentType,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.createdAt,
    required this.happenedAt,
  });

  @override
  List<Object?> get props => [id, incidentType, description, latitude, longitude, imageUrl];
}