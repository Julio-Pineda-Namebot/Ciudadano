import "package:ciudadano/features/sidebar/safe_route/data/datasources/route_remote_datasource.dart";
import "package:ciudadano/features/sidebar/safe_route/domain/entities/route_step.dart";
import "package:ciudadano/features/sidebar/safe_route/domain/repository/route_repository.dart";

class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDatasource datasource;

  RouteRepositoryImpl(this.datasource);

  @override
  Future<List<RouteStep>> getRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return datasource.getRoute(startLat, startLng, endLat, endLng);
  }
}
