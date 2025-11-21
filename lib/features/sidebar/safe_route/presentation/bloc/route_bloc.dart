import "package:ciudadano/features/sidebar/safe_route/domain/usecases/get_route_usecase.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/bloc/route_event.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/bloc/route_state.dart";
import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final GetRouteUseCase getRouteUseCase;

  RouteBloc(this.getRouteUseCase) : super(RouteInitial()) {
    on<LoadRouteEvent>((event, emit) async {
      debugPrint("🚀 Cargando ruta...");
      debugPrint("   Origen: (${event.startLat}, ${event.startLng})");
      debugPrint("   Destino: (${event.endLat}, ${event.endLng})");
      debugPrint("   Incidencias a evitar: ${event.incidentsToAvoid.length}");

      emit(RouteLoading());
      try {
        final steps = await getRouteUseCase(
          event.startLat,
          event.startLng,
          event.endLat,
          event.endLng,
          event.incidentsToAvoid,
        );

        debugPrint("✅ Ruta cargada con ${steps.length} pasos");
        for (int i = 0; i < steps.length && i < 5; i++) {
          debugPrint("   Paso $i: (${steps[i].lat}, ${steps[i].lng})");
        }

        emit(RouteLoaded(steps));
      } catch (e) {
        debugPrint("❌ Error cargando la ruta: $e");
        emit(RouteError("Error cargando la ruta"));
      }
    });
  }
}
