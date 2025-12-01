import "package:equatable/equatable.dart";
import "../../domain/entities/push_notification.dart";

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationPermissionGranted extends NotificationState {}

class NotificationPermissionDenied extends NotificationState {}

class NotificationTokenRegistered extends NotificationState {
  final String token;

  const NotificationTokenRegistered(this.token);

  @override
  List<Object?> get props => [token];
}

class NotificationTokenUnregistered extends NotificationState {}

class NotificationReceived extends NotificationState {
  final List<PushNotification> notifications;
  final PushNotification? latestNotification;

  const NotificationReceived({
    required this.notifications,
    this.latestNotification,
  });

  @override
  List<Object?> get props => [notifications, latestNotification];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationInitialized extends NotificationState {
  final List<PushNotification> notifications;
  final bool permissionsGranted;
  final String? firebaseToken;

  const NotificationInitialized({
    required this.notifications,
    required this.permissionsGranted,
    this.firebaseToken,
  });

  @override
  List<Object?> get props => [notifications, permissionsGranted, firebaseToken];
}
