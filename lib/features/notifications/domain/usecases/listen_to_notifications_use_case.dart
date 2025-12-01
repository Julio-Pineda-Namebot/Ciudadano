import "../entities/push_notification.dart";
import "../repository/notification_repository.dart";

class ListenToNotificationsUseCase {
  final NotificationRepository repository;

  ListenToNotificationsUseCase(this.repository);

  Stream<PushNotification> getForegroundNotifications() {
    return repository.getForegroundNotifications();
  }

  Stream<PushNotification> getNotificationOpenedApp() {
    return repository.getNotificationOpenedApp();
  }

  Future<PushNotification?> getInitialNotification() {
    return repository.getInitialNotification();
  }
}
