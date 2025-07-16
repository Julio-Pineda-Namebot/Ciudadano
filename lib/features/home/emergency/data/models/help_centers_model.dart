class CentroModel {
  final String nombre;
  final String tipo;
  final String direccion;
  final double lat;
  final double lng;

  CentroModel({
    required this.nombre,
    required this.tipo,
    required this.direccion,
    required this.lat,
    required this.lng,
  });

  factory CentroModel.fromJson(Map<String, dynamic> json) {
    return CentroModel(
      nombre: json["nombre"],
      tipo: json["tipo"],
      direccion: json["direccion"],
      lat: json["lat"],
      lng: json["lng"],
    );
  }
}
