import "package:ciudadano/features/home/comunity/domain/entities/event.dart";
import "package:ciudadano/features/home/comunity/domain/repository/event_repository.dart";

class GetEventos {
  final EventoRepository repo;
  GetEventos(this.repo);
  Future<List<Evento>> call() => repo.obtenerEventos();
}
