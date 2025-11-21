import "package:ciudadano/features/incidents/domain/entities/incident.dart";

abstract class RouteEvent {}

class LoadRouteEvent extends RouteEvent {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final List<Incident> incidentsToAvoid;

  LoadRouteEvent(
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
    this.incidentsToAvoid,
  );
}
