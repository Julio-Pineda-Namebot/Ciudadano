import "package:equatable/equatable.dart";

class Evento extends Equatable {
  final int id;
  final String nombre;
  final DateTime fecha;
  final bool joined;

  const Evento({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.joined,
  });

  @override
  List<Object?> get props => [id, nombre, fecha, joined];

  Evento copyWith({bool? joined}) => Evento(
    id: id,
    nombre: nombre,
    fecha: fecha,
    joined: joined ?? this.joined,
  );
}
