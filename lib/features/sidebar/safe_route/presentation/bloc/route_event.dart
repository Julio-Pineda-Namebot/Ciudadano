abstract class RouteEvent {}

class LoadRouteEvent extends RouteEvent {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  LoadRouteEvent(this.startLat, this.startLng, this.endLat, this.endLng);
}
