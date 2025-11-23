import "package:dio/dio.dart";
import "package:logger/logger.dart";

class LoggerInterceptor extends Interceptor {
  Logger logger;

  LoggerInterceptor(this.logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = "${options.baseUrl}${options.path}";
    logger.e("${options.method} request ==> $requestPath"); //Error log
    logger.d(
      "Error type: ${err.error} \n "
      "Error message: ${err.message}",
    ); //Debug log
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    final requestPath = "${options.baseUrl}${options.path}";
    logger.i("${options.method} request ==> $requestPath"); //Info log
    logger.i("Data: ${response.data}"); // Debug log
    handler.next(response);
  }
}
