import "package:dartz/dartz.dart";
import "../entities/push_notification.dart";

abstract class NotificationRepository {
  /// Inicializar Firebase y solicitar permisos
  Future<Either<String, bool>> initializeFirebaseMessaging();

  /// Obtener el token FCM del dispositivo
  Future<Either<String, String>> getFirebaseToken();

  /// Registrar token en el backend
  Future<Either<String, bool>> registerPushToken(String token, String platform);

  /// Desregistrar token en el backend
  Future<Either<String, bool>> unregisterPushToken(String token);

  /// Manejar notificaciones en primer plano
  Stream<PushNotification> getForegroundNotifications();

  /// Manejar notificaciones al abrir la app
  Future<PushNotification?> getInitialNotification();

  /// Manejar notificaciones al hacer tap en background
  Stream<PushNotification> getNotificationOpenedApp();

  /// Solicitar permisos de notificación
  Future<Either<String, bool>> requestNotificationPermissions();

  /// Verificar si los permisos están concedidos
  Future<bool> areNotificationsEnabled();

  /// Mostrar notificación local
  Future<Either<String, bool>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
}
