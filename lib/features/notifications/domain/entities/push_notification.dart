import "package:equatable/equatable.dart";

class PushNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime receivedAt;
  final NotificationType type;
  final bool isRead;

  const PushNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
    required this.receivedAt,
    required this.type,
    this.isRead = false,
  });

  PushNotification copyWith({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    DateTime? receivedAt,
    NotificationType? type,
    bool? isRead,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      receivedAt: receivedAt ?? this.receivedAt,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, body, data, receivedAt, type, isRead];
}

enum NotificationType {
  emergency_alert,
  incident_update,
  chat_message,
  system_update,
  general,
}
