import "package:ciudadano/features/comunity/domain/repository/event_repository.dart";

class ToggleJoinEvento {
  final EventoRepository repo;
  ToggleJoinEvento(this.repo);
  Future<void> call(int id) => repo.toggleJoin(id);
}
