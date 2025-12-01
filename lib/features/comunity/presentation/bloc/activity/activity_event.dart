import "package:equatable/equatable.dart";

abstract class ActividadEvent extends Equatable {
  const ActividadEvent();
  @override
  List<Object?> get props => [];
}

class CargarActividades extends ActividadEvent {}

class PublicarActividad extends ActividadEvent {
  final String autor;
  final String mensaje;
  const PublicarActividad({required this.autor, required this.mensaje});
  @override
  List<Object?> get props => [autor, mensaje];
}