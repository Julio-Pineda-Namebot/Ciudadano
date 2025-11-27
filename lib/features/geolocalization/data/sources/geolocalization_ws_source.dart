import "dart:async";

import "package:ciudadano/core/ws/socket_io_client.dart";
import "package:ciudadano/features/auth/data/interceptors/auth_interceptor.dart";
import "package:ciudadano/features/incidents/data/models/incident_model.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/service_locator.dart";
import "package:latlong2/latlong.dart";

class GeolocalizationWsSource {
  final SocketIoClient socketClient;

  const GeolocalizationWsSource(this.socketClient);

  void connect(LatLng location) {
    final authData = {
      "lat": location.latitude,
      "lng": location.longitude,
      "token": sl<AuthInterceptor>().token,
    };

    socketClient.connect(authData: authData);
  }

  void disconnect() {
    socketClient.dispose();
  }

  Stream<Incident> watchIncidentsReported() {
    final controller = StreamController<Incident>();

    void onIncidentReported(dynamic data) {
      final incident = IncidentModel.fromJson(data["incident"]);
      controller.add(incident);
    }

    socketClient.socket?.on("incident:reported", onIncidentReported);

    controller.onCancel = () {
      socketClient.socket?.off("incident:reported", onIncidentReported);
    };

    return controller.stream;
  }
}
