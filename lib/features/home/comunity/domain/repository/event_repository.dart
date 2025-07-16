import "package:ciudadano/features/home/comunity/domain/entities/event.dart";

abstract class EventoRepository {
  Future<List<Evento>> obtenerEventos();
  Future<void> agregarEvento(Evento nuevo);
  Future<void> toggleJoin(int id);
}
