import "package:ciudadano/features/sidebar/safe_route/domain/entities/route_step.dart";

abstract class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final List<RouteStep> steps;

  RouteLoaded(this.steps);
}

class RouteError extends RouteState {
  final String message;

  RouteError(this.message);
}
