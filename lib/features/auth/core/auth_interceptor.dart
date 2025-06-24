import "package:dio/dio.dart";
import "package:flutter/foundation.dart";

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  String? _cachedToken;

  AuthInterceptor({required this.getToken});

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
    _cachedToken ??= await getToken();
    return _cachedToken;
  }
}
