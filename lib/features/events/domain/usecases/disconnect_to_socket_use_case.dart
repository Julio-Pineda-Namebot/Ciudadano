import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";

class DisconnectFromSocketUseCase implements UseCase<void, void> {
  final SocketRepository _socketRepository;

  const DisconnectFromSocketUseCase(this._socketRepository);

  @override
  Future<void> call(void params) async {
    _socketRepository.disconnect();
  }
}
