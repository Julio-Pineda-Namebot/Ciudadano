import "dart:async";
import "dart:io";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:permission_handler/permission_handler.dart";
import "../models/push_notification_model.dart";

abstract class NotificationLocalSource {
  Future<bool> initializeFirebase();
  Future<String?> getFirebaseToken();
  Future<bool> requestPermissions();
  Future<bool> areNotificationsEnabled();
  Stream<PushNotificationModel> getForegroundNotifications();
  Stream<PushNotificationModel> getNotificationOpenedApp();
  Future<PushNotificationModel?> getInitialNotification();
  Future<bool> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
}

class NotificationLocalSourceImpl implements NotificationLocalSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<PushNotificationModel> _foregroundController =
      StreamController<PushNotificationModel>.broadcast();
  final StreamController<PushNotificationModel> _openedAppController =
      StreamController<PushNotificationModel>.broadcast();

  @override
  Future<bool> initializeFirebase() async {
    try {
      // Configurar notificaciones locales
      const androidSettings = AndroidInitializationSettings(
        "@mipmap/ic_launcher",
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Manejar tap en notificación local
          if (response.payload != null) {
            // Aquí puedes parsear el payload y crear la notificación
            // Para este ejemplo, lo omitimos
          }
        },
      );

      // Configurar canal de notificación para Android
      if (Platform.isAndroid) {
        const androidChannel = AndroidNotificationChannel(
          "high_importance_channel",
          "High Importance Notifications",
          description: "This channel is used for important notifications.",
          importance: Importance.high,
        );

        await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(androidChannel);
      }

      // Configurar listeners de Firebase
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleForegroundMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessageOpenedApp(message);
      });

      return true;
    } catch (e) {
      print("Error initializing Firebase: $e");
      return false;
    }
  }

  @override
  Future<String?> getFirebaseToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print("Error getting Firebase token: $e");
      return null;
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      // Solicitar permisos de Firebase
      final NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("User granted permission");
        return true;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print("User granted provisional permission");
        return true;
      } else {
        print("User declined or has not accepted permission");
        return false;
      }
    } catch (e) {
      print("Error requesting permissions: $e");
      return false;
    }
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    try {
      final NotificationSettings settings =
          await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      print("Error checking notification permissions: $e");
      return false;
    }
  }

  @override
  Stream<PushNotificationModel> getForegroundNotifications() {
    return _foregroundController.stream;
  }

  @override
  Stream<PushNotificationModel> getNotificationOpenedApp() {
    return _openedAppController.stream;
  }

  @override
  Future<PushNotificationModel?> getInitialNotification() async {
    try {
      final RemoteMessage? initialMessage =
          await _firebaseMessaging.getInitialMessage();

      if (initialMessage != null) {
        return PushNotificationModel.fromFirebaseMessage(
          initialMessage.toMap(),
        );
      }
      return null;
    } catch (e) {
      print("Error getting initial notification: $e");
      return null;
    }
  }

  @override
  Future<bool> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        "high_importance_channel",
        "High Importance Notifications",
        channelDescription: "This channel is used for important notifications.",
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: data?.toString(),
      );

      return true;
    } catch (e) {
      print("Error showing local notification: $e");
      return false;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = PushNotificationModel.fromFirebaseMessage(
      message.toMap(),
    );
    _foregroundController.add(notification);

    // Mostrar notificación local cuando la app está en primer plano
    showLocalNotification(
      title: notification.title,
      body: notification.body,
      data: notification.data,
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final notification = PushNotificationModel.fromFirebaseMessage(
      message.toMap(),
    );
    _openedAppController.add(notification);
  }

  void dispose() {
    _foregroundController.close();
    _openedAppController.close();
  }
}
