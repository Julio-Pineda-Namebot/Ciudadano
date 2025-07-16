import "package:ciudadano/features/home/comunity/domain/entities/activity.dart";
import "package:ciudadano/features/home/comunity/domain/usecases/activity/add_activity.dart";
import "package:ciudadano/features/home/comunity/domain/usecases/activity/get_activity.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/activity/activity_event.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/activity/activity_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ActividadBloc extends Bloc<ActividadEvent, ActividadState> {
  final GetActividades getActividades;
  final AddActividad addActividad;

  ActividadBloc({required this.getActividades, required this.addActividad})
    : super(ActividadInitial()) {
    on<CargarActividades>(_onCargar);
    on<PublicarActividad>(_onPublicar);
  }

  Future<void> _onCargar(
    CargarActividades event,
    Emitter<ActividadState> emit,
  ) async {
    emit(ActividadLoading());
    try {
      final actividades = await getActividades();
      emit(ActividadLoaded(actividades));
    } catch (e) {
      emit(const ActividadError("Error cargando actividades"));
    }
  }

  Future<void> _onPublicar(
    PublicarActividad event,
    Emitter<ActividadState> emit,
  ) async {
    if (state is! ActividadLoaded) {
      return;
    }
    // ignore: unused_local_variable
    final loaded = state as ActividadLoaded;
    final nueva = Actividad(autor: event.autor, mensaje: event.mensaje);
    await addActividad(nueva);
    final actividadesActualizadas = await getActividades();
    emit(ActividadLoaded(actividadesActualizadas));
  }
}
