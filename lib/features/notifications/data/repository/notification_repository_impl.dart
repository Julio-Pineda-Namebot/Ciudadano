import "package:dartz/dartz.dart";
import "../../domain/entities/push_notification.dart";
import "../../domain/repository/notification_repository.dart";
import "../source/notification_api_source.dart";
import "../source/notification_local_source.dart";

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalSource localSource;
  final NotificationApiSource apiSource;

  NotificationRepositoryImpl({
    required this.localSource,
    required this.apiSource,
  });

  @override
  Future<Either<String, bool>> initializeFirebaseMessaging() async {
    try {
      final result = await localSource.initializeFirebase();
      if (result) {
        return const Right(true);
      } else {
        return const Left("Failed to initialize Firebase messaging");
      }
    } catch (e) {
      return Left("Error initializing Firebase: $e");
    }
  }

  @override
  Future<Either<String, String>> getFirebaseToken() async {
    try {
      final token = await localSource.getFirebaseToken();
      if (token != null) {
        return Right(token);
      } else {
        return const Left("Failed to get Firebase token");
      }
    } catch (e) {
      return Left("Error getting Firebase token: $e");
    }
  }

  @override
  Future<Either<String, bool>> registerPushToken(
    String token,
    String platform,
  ) async {
    try {
      final result = await apiSource.registerPushToken(token, platform);
      if (result) {
        return const Right(true);
      } else {
        return const Left("Failed to register push token");
      }
    } catch (e) {
      return Left("Error registering push token: $e");
    }
  }

  @override
  Future<Either<String, bool>> unregisterPushToken(String token) async {
    try {
      final result = await apiSource.unregisterPushToken(token);
      if (result) {
        return const Right(true);
      } else {
        return const Left("Failed to unregister push token");
      }
    } catch (e) {
      return Left("Error unregistering push token: $e");
    }
  }

  @override
  Stream<PushNotification> getForegroundNotifications() {
    return localSource.getForegroundNotifications();
  }

  @override
  Future<PushNotification?> getInitialNotification() async {
    try {
      return await localSource.getInitialNotification();
    } catch (e) {
      print("Error getting initial notification: $e");
      return null;
    }
  }

  @override
  Stream<PushNotification> getNotificationOpenedApp() {
    return localSource.getNotificationOpenedApp();
  }

  @override
  Future<Either<String, bool>> requestNotificationPermissions() async {
    try {
      final result = await localSource.requestPermissions();
      if (result) {
        return const Right(true);
      } else {
        return const Left("Permission denied by user");
      }
    } catch (e) {
      return Left("Error requesting permissions: $e");
    }
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    try {
      return await localSource.areNotificationsEnabled();
    } catch (e) {
      print("Error checking notification permissions: $e");
      return false;
    }
  }

  @override
  Future<Either<String, bool>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final result = await localSource.showLocalNotification(
        title: title,
        body: body,
        data: data,
      );
      if (result) {
        return const Right(true);
      } else {
        return const Left("Failed to show local notification");
      }
    } catch (e) {
      return Left("Error showing local notification: $e");
    }
  }
}
