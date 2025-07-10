import "package:ciudadano/features/incidents/domain/entities/create_incident.dart";
import "package:dio/dio.dart";

class CreateIncidentModel extends CreateIncident {
  const CreateIncidentModel({
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
      "location_lat": location.latitude,
      "location_lon": location.longitude,
    });
  }
}
