import "package:ciudadano/features/home/comunity/domain/entities/event.dart";
import "package:equatable/equatable.dart";

abstract class EventoState extends Equatable {
  const EventoState();
  @override
  List<Object?> get props => [];
}

class EventoInitial extends EventoState {}

class EventoLoading extends EventoState {}

class EventoLoaded extends EventoState {
  final List<Evento> eventos;
  const EventoLoaded(this.eventos);
  @override
  List<Object?> get props => [eventos];
}

class EventoError extends EventoState {
  final String msg;
  const EventoError(this.msg);
  @override
  List<Object?> get props => [msg];
}
