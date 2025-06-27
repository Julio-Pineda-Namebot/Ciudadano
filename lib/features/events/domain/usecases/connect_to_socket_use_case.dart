import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";
import "package:latlong2/latlong.dart";

class ConnectToSocketUseCase implements UseCase<void, LatLng> {
  final SocketRepository _socketRepository;

  const ConnectToSocketUseCase(this._socketRepository);

  @override
  Future<void> call(LatLng location) async {
    await _socketRepository.connect(location);
  }
}
