import "package:ciudadano/features/home/comunity/domain/entities/event.dart";

class EventoModel extends Evento {
  const EventoModel({
    required super.id,
    required super.nombre,
    required super.fecha,
    required super.joined,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) => EventoModel(
    id: json["id"] as int,
    nombre: json["nombre"] as String,
    fecha: DateTime.parse(json["fecha"] as String),
    joined: json["joined"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "fecha": fecha.toIso8601String(),
    "joined": joined,
  };
}
