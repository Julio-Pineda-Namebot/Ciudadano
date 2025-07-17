import "package:ciudadano/features/sidebar/safe_route/domain/entities/route_step.dart";

class RouteStepModel extends RouteStep {
  RouteStepModel({
    required super.instruction,
    required super.lat,
    required super.lng,
  });

  factory RouteStepModel.fromJson(Map<String, dynamic> json) {
    return RouteStepModel(
      instruction: json["instruction"],
      lat: json["lat"],
      lng: json["lng"],
    );
  }
}
