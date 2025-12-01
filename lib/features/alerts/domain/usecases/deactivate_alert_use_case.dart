import "package:dartz/dartz.dart";
import "../repository/alert_repository.dart";

class DeactivateAlertUseCase {
  final AlertRepository repository;

  DeactivateAlertUseCase(this.repository);

  Future<Either<String, bool>> call(String alertId) async {
    return await repository.deactivateAlert(alertId);
  }
}
