import "package:dartz/dartz.dart";
import "../entities/alert.dart";

abstract class AlertRepository {
  Future<Either<String, Alert>> createAlert({
    required double latitude,
    required double longitude,
    String? address,
    String? message,
  });

  Future<Either<String, bool>> deactivateAlert(String alertId);

  Future<Either<String, List<Alert>>> getUserAlerts();

  Future<Either<String, Alert?>> getActiveAlert();
}
