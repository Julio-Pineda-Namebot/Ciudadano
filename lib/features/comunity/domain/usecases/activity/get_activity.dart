import "package:ciudadano/features/comunity/domain/entities/activity.dart";
import "package:ciudadano/features/comunity/domain/repository/activity_repository.dart";

class GetActividades {
  final ActividadRepository repo;
  GetActividades(this.repo);

  Future<List<Actividad>> call() => repo.obtenerActividades();
}
