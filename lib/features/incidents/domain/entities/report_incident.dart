import "dart:io";

import "package:dio/dio.dart";
import "package:latlong2/latlong.dart";

abstract class ReportIncident {
  final String incidentType;
  final String description;
  final File image;
  final LatLng location;

  const ReportIncident({
    required this.incidentType,
    required this.description,
    required this.image,
    required this.location,
  });

  Future<FormData> toFormData();
}
