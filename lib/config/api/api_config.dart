mixin ApiConfig {
  static const String productionUrl = "https://ciudadano.onrender.com";
  static const String developmentUrl = "http://192.168.0.2:3000";

  static String get ac {
    return productionUrl;
  }
}
