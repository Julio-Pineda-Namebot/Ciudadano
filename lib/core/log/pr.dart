import "package:ciudadano/service_locator.dart";
import "package:logger/logger.dart";

void pr(dynamic message) {
  sl<Logger>().i(message);
}
