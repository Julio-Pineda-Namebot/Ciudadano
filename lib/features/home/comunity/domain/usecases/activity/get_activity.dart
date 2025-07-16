import "package:ciudadano/features/home/comunity/domain/entities/activity.dart";
import "package:ciudadano/features/home/comunity/domain/repository/activity_repository.dart";

class GetActividades {
  final ActividadRepository repo;
  GetActividades(this.repo);

  Future<List<Actividad>> call() => repo.obtenerActividades();
}
