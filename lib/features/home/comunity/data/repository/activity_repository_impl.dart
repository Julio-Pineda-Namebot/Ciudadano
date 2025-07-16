import "package:ciudadano/features/home/comunity/data/datasource/activity_local_datasource.dart";
import "package:ciudadano/features/home/comunity/domain/entities/activity.dart";
import "package:ciudadano/features/home/comunity/domain/repository/activity_repository.dart";

class ActividadRepositoryImpl implements ActividadRepository {
  final ActividadLocalDatasource datasource;

  List<Actividad> _cache = const [];

  ActividadRepositoryImpl({required this.datasource});

  @override
  Future<List<Actividad>> obtenerActividades() async {
    if (_cache.isEmpty) {
      _cache = await datasource.getActividades();
    }
    return _cache;
  }

  @override
  Future<void> agregarActividad(Actividad nueva) async {
    _cache = [nueva, ..._cache];
  }
}
