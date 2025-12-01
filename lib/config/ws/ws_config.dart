mixin WsConfig {
  static const String productionUrl = "wss://ciudadano-api-rest.onrender.com";
  static const String developmentUrl = "ws://192.168.0.3:3000";

  static String get baseUrl {
    return productionUrl;
  }
}
