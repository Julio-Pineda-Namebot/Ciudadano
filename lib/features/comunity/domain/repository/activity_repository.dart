import "package:ciudadano/features/comunity/domain/entities/activity.dart";

abstract class ActividadRepository {
  Future<List<Actividad>> obtenerActividades();
  Future<void> agregarActividad(Actividad nueva);
}
