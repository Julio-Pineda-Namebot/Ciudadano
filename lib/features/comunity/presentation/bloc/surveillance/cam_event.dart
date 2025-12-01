import "package:equatable/equatable.dart";

abstract class CamEvent extends Equatable {
  const CamEvent();
  @override
  List<Object?> get props => [];
}

class CargarCamaras extends CamEvent {}
