import "package:dartz/dartz.dart";
import "../entities/alert.dart";
import "../repository/alert_repository.dart";

class CreateAlertUseCase {
  final AlertRepository repository;

  CreateAlertUseCase(this.repository);

  Future<Either<String, Alert>> call({
    required double latitude,
    required double longitude,
    String? address,
    String? message,
  }) async {
    return await repository.createAlert(
      latitude: latitude,
      longitude: longitude,
      address: address,
      message: message,
    );
  }
}
