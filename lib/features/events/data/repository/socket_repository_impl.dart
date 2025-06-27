import "package:ciudadano/features/events/data/source/socket_source.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";
import "package:ciudadano/features/incidents/data/models/incident_model.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:latlong2/latlong.dart";

class SocketRepositoryImpl implements SocketRepository {
  final SocketSource _socketSource;

  const SocketRepositoryImpl(this._socketSource);

  @override
  Future<void> connect(LatLng location) async {
    await _socketSource.connect(location);
  }

  @override
  void disconnect() {
    _socketSource.disconnect();
  }

  @override
  void listenIncidentsReported(Function(Incident incident) onIncidentReported) {
    _socketSource.subscribeChannel(
      "incident:reported",
      onData: (data) => onIncidentReported(IncidentModel.fromJson(data)),
    );
  }

  @override
  void disconnectIncidentsReported() {
    _socketSource.disconnectChannel("incident:reported");
  }
}
