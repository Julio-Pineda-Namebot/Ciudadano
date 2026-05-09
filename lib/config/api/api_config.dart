mixin ApiConfig {
  static const String productionUrl = "https://ciudadano-rest-api.onrender.com";
  static const String developmentUrl = "http://192.168.0.3:3000";

  static String get baseUrl {
    return productionUrl;
  }
}
