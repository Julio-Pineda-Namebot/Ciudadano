mixin ApiConfig {
  static const String productionUrl =
      "https://ciudadano-production.up.railway.app";
  static const String developmentUrl = "http://192.168.0.7:3000";

  static String get ac {
    return developmentUrl;
  }
}
