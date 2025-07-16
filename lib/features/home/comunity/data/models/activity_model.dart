import "package:ciudadano/features/home/comunity/domain/entities/activity.dart";

class ActividadModel extends Actividad {
  const ActividadModel({required super.autor, required super.mensaje});

  factory ActividadModel.fromJson(Map<String, dynamic> json) => ActividadModel(
    autor: json["autor"] as String,
    mensaje: json["mensaje"] as String,
  );

  Map<String, dynamic> toJson() => {"autor": autor, "mensaje": mensaje};
}
