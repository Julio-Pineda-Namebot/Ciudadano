import "package:ciudadano/features/sidebar/safe_route/domain/entities/route_step.dart";
import "package:ciudadano/features/sidebar/safe_route/domain/repository/route_repository.dart";

class GetRouteUseCase {
  final RouteRepository repository;

  GetRouteUseCase(this.repository);

  Future<List<RouteStep>> call(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return repository.getRoute(startLat, startLng, endLat, endLng);
  }
}
