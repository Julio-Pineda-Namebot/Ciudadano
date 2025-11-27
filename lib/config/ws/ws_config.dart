mixin WsConfig {
  static const String productionUrl = "wss://ciudadano-ws.onrender.com";
  static const String developmentUrl = "ws://192.168.0.2:3000";

  static String get baseUrl {
    return developmentUrl;
  }
}
