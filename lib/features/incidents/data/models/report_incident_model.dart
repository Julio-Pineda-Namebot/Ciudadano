import "package:ciudadano/features/incidents/domain/entities/report_incident.dart";
import "package:dio/dio.dart";

class ReportIncidentModel extends ReportIncident {
  const ReportIncidentModel({
    required super.incidentType,
    required super.description,
    required super.image,
    required super.location,
  });

  @override
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "description": description,
      "incident_type": incidentType,
      "multimedia": await MultipartFile.fromFile(
        image.path,
        contentType: DioMediaType("image", image.path.split(".").last),
      ),
      "latitude": location.latitude,
      "longitude": location.longitude,
    });
  }
}
