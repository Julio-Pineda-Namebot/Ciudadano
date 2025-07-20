import "package:firebase_messaging/firebase_messaging.dart";

/// Manejador de notificaciones en background
/// Este método se ejecuta cuando la app está completamente cerrada
/// y llega una notificación push.
@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inicializar Firebase si es necesario
  // await Firebase.initializeApp();

  print("Background message received: ${message.messageId}");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Data: ${message.data}");

  // Aquí puedes procesar la notificación:
  // - Guardar en base de datos local
  // - Mostrar notificación local personalizada
  // - Actualizar badges o contadores

  // Manejar diferentes tipos de notificación
  final notificationType = message.data["type"];
  switch (notificationType) {
    case "emergency_alert":
      print("Processing emergency alert in background");
      // Lógica específica para alertas de emergencia
      break;
    case "incident_update":
      print("Processing incident update in background");
      // Lógica específica para actualizaciones de incidentes
      break;
    case "chat_message":
      print("Processing chat message in background");
      // Lógica específica para mensajes de chat
      break;
    default:
      print("Processing general notification in background");
  }
}
