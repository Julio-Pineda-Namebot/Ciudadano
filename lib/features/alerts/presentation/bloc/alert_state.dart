import "../../domain/entities/alert.dart";

abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertActivated extends AlertState {
  final Alert alert;

  AlertActivated(this.alert);
}

class AlertDeactivated extends AlertState {}

class AlertError extends AlertState {
  final String message;

  AlertError(this.message);
}

class AlertsLoaded extends AlertState {
  final List<Alert> alerts;
  final Alert? activeAlert;

  AlertsLoaded(this.alerts, {this.activeAlert});
}
