import "package:dartz/dartz.dart";
import "../repository/notification_repository.dart";

class RequestNotificationPermissionsUseCase {
  final NotificationRepository repository;

  RequestNotificationPermissionsUseCase(this.repository);

  Future<Either<String, bool>> call() async {
    return await repository.requestNotificationPermissions();
  }
}
