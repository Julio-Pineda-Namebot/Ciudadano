class ContactoModel {
  final String nombre;
  final String numero;
  final String icono;

  ContactoModel({
    required this.nombre,
    required this.numero,
    required this.icono,
  });

  factory ContactoModel.fromJson(Map<String, dynamic> json) {
    return ContactoModel(
      nombre: json["nombre"],
      numero: json["numero"],
      icono: json["icono"],
    );
  }
}
