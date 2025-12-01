import "package:dartz/dartz.dart";
import "../repository/notification_repository.dart";

class RegisterPushTokenUseCase {
  final NotificationRepository repository;

  RegisterPushTokenUseCase(this.repository);

  Future<Either<String, bool>> call(String token, String platform) async {
    return await repository.registerPushToken(token, platform);
  }
}
