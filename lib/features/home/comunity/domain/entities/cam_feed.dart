import "package:equatable/equatable.dart";

class CamFeed extends Equatable {
  final int id;
  final String titulo;
  final String gifPath;

  const CamFeed({
    required this.id,
    required this.titulo,
    required this.gifPath,
  });

  @override
  List<Object?> get props => [id, titulo, gifPath];
}
