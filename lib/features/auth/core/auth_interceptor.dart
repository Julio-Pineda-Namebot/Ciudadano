import "package:ciudadano/service_locator.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class AuthInterceptor extends Interceptor {
  String? _cachedToken;

  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();

  AuthInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getCachedToken();
    debugPrint("Token: $token");
    options.headers["Authorization"] = "Bearer $token";
    return handler.next(options);
  }

  Future<String?> getCachedToken() async {
    _cachedToken = await secureStorage.read(key: "auth_token");
    return _cachedToken;
  }
}
