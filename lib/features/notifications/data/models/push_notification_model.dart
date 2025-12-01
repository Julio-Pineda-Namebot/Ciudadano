import "../../domain/entities/push_notification.dart";

class PushNotificationModel extends PushNotification {
  const PushNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.data,
    required super.receivedAt,
    required super.type,
    super.isRead,
  });

  factory PushNotificationModel.fromMap(Map<String, dynamic> map) {
    return PushNotificationModel(
      id: map["messageId"] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map["notification"]?["title"] ?? "",
      body: map["notification"]?["body"] ?? "",
      data: Map<String, dynamic>.from(map["data"] ?? {}),
      receivedAt: DateTime.now(),
      type: _parseNotificationType(map["data"]?["type"] ?? "general"),
      isRead: false,
    );
  }

  factory PushNotificationModel.fromFirebaseMessage(
    Map<String, dynamic> message,
  ) {
    return PushNotificationModel(
      id:
          message["messageId"] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: message["notification"]?["title"] ?? "",
      body: message["notification"]?["body"] ?? "",
      data: Map<String, dynamic>.from(message["data"] ?? {}),
      receivedAt: DateTime.now(),
      type: _parseNotificationType(message["data"]?["type"] ?? "general"),
      isRead: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "data": data,
      "receivedAt": receivedAt.toIso8601String(),
      "type": type.toString().split(".").last,
      "isRead": isRead,
    };
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case "emergency_alert":
        return NotificationType.emergency_alert;
      case "incident_update":
        return NotificationType.incident_update;
      case "chat_message":
        return NotificationType.chat_message;
      case "system_update":
        return NotificationType.system_update;
      default:
        return NotificationType.general;
    }
  }
}
