import "package:dartz/dartz.dart";
import "../entities/alert.dart";
import "../repository/alert_repository.dart";

class GetActiveAlertUseCase {
  final AlertRepository repository;

  GetActiveAlertUseCase(this.repository);

  Future<Either<String, Alert?>> call() async {
    return await repository.getActiveAlert();
  }
}
