import 'package:ciudadano/features/home/incidents/data/models/incident_model.dart';
import 'package:dio/dio.dart';
import 'package:ciudadano/config/core/dio_cliente.dart';

class IncidentRemoteDatasource {
  final DioClient _dio = DioClient();

  Future<List<IncidentModel>> getIncidents() async {
    try {
      final response = await _dio.get('/incidents/');

      if (response.statusCode == 200) {
        final data = response.data;
        final incidentList = data['data'] as List;
        return incidentList.map((e) => IncidentModel.fromJson(e)).toList();
      } else {
        throw Exception('Error inesperado. Código: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'No se pudieron cargar los incidentes';
      throw Exception(msg);
    }
  }
  
  // Future<List<IncidentModel>> getIncidents() async {
  //   await Future.delayed(Duration(seconds: 1));

  //   return [
  //     IncidentModel(
  //       id: '1',
  //       incidentType: 'Robo',
  //       description: 'Robo reportado en la zona centro',
  //       latitude: -14.067275,
  //       longitude: -75.731180,
  //       imageUrl: 'https://res.cloudinary.com/dieitr1hd/image/upload/v1745120965/imagen_2025-04-19_224922999_jtu2v0.png',
  //       createdAt: DateTime.now().subtract(Duration(hours: 5)),
  //       happenedAt: DateTime.now().subtract(Duration(hours: 6)),
  //     ),
  //     IncidentModel(
  //       id: '2',
  //       incidentType: 'Incendio',
  //       description: 'Incendio en edificio de departamentos',
  //       latitude: -14.068143,
  //       longitude: -75.731235,
  //       imageUrl: 'https://res.cloudinary.com/dieitr1hd/image/upload/v1745120965/imagen_2025-04-19_224922999_jtu2v0.png',
  //       createdAt: DateTime.now().subtract(Duration(days: 1)),
  //       happenedAt: DateTime.now().subtract(Duration(days: 1, hours: 2)),
  //     ),
  //     IncidentModel(
  //       id: '3',
  //       incidentType: 'Accidente',
  //       description: 'Accidente de tránsito leve',
  //       latitude: -14.070841,
  //       longitude: -75.728912,
  //       imageUrl: 'https://res.cloudinary.com/dieitr1hd/image/upload/v1745120965/imagen_2025-04-19_224922999_jtu2v0.png',
  //       createdAt: DateTime.now().subtract(Duration(minutes: 30)),
  //       happenedAt: DateTime.now().subtract(Duration(minutes: 45)),
  //     ),
  //   ];
  // }
}
