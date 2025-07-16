import "package:ciudadano/features/home/comunity/data/datasource/event_local_datasource.dart";
import "package:ciudadano/features/home/comunity/domain/entities/event.dart";
import "package:ciudadano/features/home/comunity/domain/repository/event_repository.dart";

class EventoRepositoryImpl implements EventoRepository {
  final EventoLocalDatasource datasource;

  EventoRepositoryImpl({required this.datasource});

  List<Evento> _cache = const [];

  @override
  Future<List<Evento>> obtenerEventos() async {
    if (_cache.isEmpty) {
      _cache = await datasource.getEventos();
    }
    return _cache;
  }

  @override
  Future<void> agregarEvento(Evento nuevo) async {
    _cache = [nuevo, ..._cache];
  }

  @override
  Future<void> toggleJoin(int id) async {
    _cache =
        _cache
            .map((e) => e.id == id ? e.copyWith(joined: !e.joined) : e)
            .toList();
  }
}
