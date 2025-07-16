import "package:ciudadano/features/home/comunity/domain/usecases/surveillance/get_cam_feeds.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_event.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class CamBloc extends Bloc<CamEvent, CamState> {
  final GetCamFeeds getFeeds;
  CamBloc({required this.getFeeds}) : super(CamInitial()) {
    on<CargarCamaras>(_onLoad);
  }

  Future<void> _onLoad(CargarCamaras e, Emitter emit) async {
    emit(CamLoading());
    try {
      emit(CamLoaded(await getFeeds()));
    } catch (_) {
      emit(const CamError("Error cargando cámaras"));
    }
  }
}