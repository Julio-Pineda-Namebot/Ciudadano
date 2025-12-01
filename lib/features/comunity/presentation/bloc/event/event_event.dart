import "package:equatable/equatable.dart";

abstract class EventoEvent extends Equatable {
  const EventoEvent();
  @override
  List<Object?> get props => [];
}

class CargarEventos extends EventoEvent {}

class CrearEvento extends EventoEvent {
  final String nombre;
  final DateTime fecha;
  const CrearEvento({required this.nombre, required this.fecha});
  @override
  List<Object?> get props => [nombre, fecha];
}

class UnirseEvento extends EventoEvent {
  final int id;
  const UnirseEvento(this.id);
  @override
  List<Object?> get props => [id];
}