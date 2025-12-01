import "package:ciudadano/features/comunity/domain/entities/event.dart";
import "package:ciudadano/features/comunity/domain/repository/event_repository.dart";

class AddEvento {
  final EventoRepository repo;
  AddEvento(this.repo);
  Future<void> call(Evento nuevo) => repo.agregarEvento(nuevo);
}
