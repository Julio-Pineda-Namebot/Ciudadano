mixin ApiConfig {
  static const String productionUrl =
      "https://ciudadano-production.up.railway.app";
  static const String developmentUrl = "http://192.168.0.2:3000";

  static String get ac {
    return developmentUrl;
  }
}
