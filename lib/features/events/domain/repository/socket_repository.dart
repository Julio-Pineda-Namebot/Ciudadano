import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:latlong2/latlong.dart";

abstract class SocketRepository {
  Future<void> connect(LatLng location);
  void disconnect();

  // Incidents
  void listenIncidentsReported(Function(Incident incident) onIncidentReported);
  void disconnectIncidentsReported();
}
