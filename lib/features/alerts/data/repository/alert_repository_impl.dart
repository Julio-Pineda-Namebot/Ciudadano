import "package:dartz/dartz.dart";
import "../../domain/entities/alert.dart";
import "../../domain/repository/alert_repository.dart";
import "../source/alert_remote_data_source.dart";

class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource remoteDataSource;

  AlertRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, Alert>> createAlert({
    required double latitude,
    required double longitude,
    String? address,
    String? message,
  }) async {
    try {
      final alert = await remoteDataSource.createAlert(
        latitude: latitude,
        longitude: longitude,
        address: address,
        message: message,
      );
      return Right(alert);
    } catch (e) {
      return Left("Error creating alert: $e");
    }
  }

  @override
  Future<Either<String, bool>> deactivateAlert(String alertId) async {
    try {
      final success = await remoteDataSource.deactivateAlert(alertId);
      return Right(success);
    } catch (e) {
      return Left("Error deactivating alert: $e");
    }
  }

  @override
  Future<Either<String, List<Alert>>> getUserAlerts() async {
    try {
      final alerts = await remoteDataSource.getUserAlerts();
      return Right(alerts);
    } catch (e) {
      return Left("Error getting alerts: $e");
    }
  }

  @override
  Future<Either<String, Alert?>> getActiveAlert() async {
    try {
      final alert = await remoteDataSource.getActiveAlert();
      return Right(alert);
    } catch (e) {
      return Left("Error getting active alert: $e");
    }
  }
}
