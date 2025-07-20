import "package:equatable/equatable.dart";
import "../../domain/entities/push_notification.dart";

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class InitializeNotifications extends NotificationEvent {}

class RequestNotificationPermissions extends NotificationEvent {}

class RegisterPushToken extends NotificationEvent {
  final String token;
  final String platform;

  const RegisterPushToken({required this.token, required this.platform});

  @override
  List<Object?> get props => [token, platform];
}

class UnregisterPushToken extends NotificationEvent {
  final String token;

  const UnregisterPushToken(this.token);

  @override
  List<Object?> get props => [token];
}

class NotificationReceived extends NotificationEvent {
  final PushNotification notification;

  const NotificationReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class ClearAllNotifications extends NotificationEvent {}

class HandleNotificationTap extends NotificationEvent {
  final PushNotification notification;

  const HandleNotificationTap(this.notification);

  @override
  List<Object?> get props => [notification];
}
