import "package:ciudadano/features/safe_route/domain/entities/route_step.dart";

abstract class RouteRepository {
  Future<List<RouteStep>> getRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  );
}
