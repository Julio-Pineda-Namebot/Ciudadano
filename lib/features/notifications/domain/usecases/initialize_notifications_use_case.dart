import "package:dartz/dartz.dart";
import "../repository/notification_repository.dart";

class InitializeNotificationsUseCase {
  final NotificationRepository repository;

  InitializeNotificationsUseCase(this.repository);

  Future<Either<String, bool>> call() async {
    return await repository.initializeFirebaseMessaging();
  }
}
