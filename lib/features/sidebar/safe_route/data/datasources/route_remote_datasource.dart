import "dart:convert";
import "package:flutter/services.dart";
import "package:ciudadano/features/sidebar/safe_route/data/models/route_step_model.dart";

class RouteRemoteDatasource {
  Future<List<RouteStepModel>> getRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    final data = await rootBundle.loadString(
      "assets/data/mock_route.json",
    );
    final decoded = json.decode(data) as List;
    return decoded.map((e) => RouteStepModel.fromJson(e)).toList();
  }
}
