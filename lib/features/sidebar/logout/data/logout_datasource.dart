import "package:flutter_secure_storage/flutter_secure_storage.dart";

class LogoutDatasource {
  final FlutterSecureStorage secureStorage;

  LogoutDatasource(this.secureStorage);

  Future<void> clearToken() async {
    await secureStorage.delete(key: "auth_token");
  }
}
