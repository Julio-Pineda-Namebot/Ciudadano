import "package:ciudadano/features/home/comunity/domain/entities/activity.dart";
import "package:ciudadano/features/home/comunity/domain/repository/activity_repository.dart";

class AddActividad {
  final ActividadRepository repo;
  AddActividad(this.repo);

  Future<void> call(Actividad nueva) => repo.agregarActividad(nueva);
}
