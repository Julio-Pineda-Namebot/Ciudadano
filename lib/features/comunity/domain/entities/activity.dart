import "package:equatable/equatable.dart";

class Actividad extends Equatable {
  final String autor;
  final String mensaje;

  const Actividad({required this.autor, required this.mensaje});

  @override
  List<Object?> get props => [autor, mensaje];

  Actividad copyWith({String? autor, String? mensaje}) =>
      Actividad(autor: autor ?? this.autor, mensaje: mensaje ?? this.mensaje);
}
