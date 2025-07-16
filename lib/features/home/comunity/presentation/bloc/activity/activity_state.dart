import "package:ciudadano/features/home/comunity/domain/entities/activity.dart";
import "package:equatable/equatable.dart";

abstract class ActividadState extends Equatable {
  const ActividadState();
  @override
  List<Object?> get props => [];
}

class ActividadInitial extends ActividadState {}

class ActividadLoading extends ActividadState {}

class ActividadLoaded extends ActividadState {
  final List<Actividad> actividades;
  const ActividadLoaded(this.actividades);
  @override
  List<Object?> get props => [actividades];
}

class ActividadError extends ActividadState {
  final String mensaje;
  const ActividadError(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}