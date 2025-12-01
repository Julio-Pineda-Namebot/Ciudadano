abstract class AlertEvent {}

class ActivateEmergencyAlert extends AlertEvent {
  final double latitude;
  final double longitude;
  final String? address;

  ActivateEmergencyAlert({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

class DeactivateEmergencyAlert extends AlertEvent {}

class CheckActiveAlert extends AlertEvent {}

class LoadUserAlerts extends AlertEvent {}
