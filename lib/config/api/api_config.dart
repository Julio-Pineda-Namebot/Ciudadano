mixin ApiConfig {
  static const String productionUrl = "https://ciudadano-api-rest.onrender.com";
  static const String developmentUrl = "http://172.17.224.1:3000";

  static String get baseUrl {
    return developmentUrl;
  }
}
