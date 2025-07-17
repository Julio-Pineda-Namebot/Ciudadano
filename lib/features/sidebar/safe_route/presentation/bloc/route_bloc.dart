import "package:ciudadano/features/sidebar/safe_route/domain/usecases/get_route_usecase.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/bloc/route_event.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/bloc/route_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final GetRouteUseCase getRouteUseCase;

  RouteBloc(this.getRouteUseCase) : super(RouteInitial()) {
    on<LoadRouteEvent>((event, emit) async {
      emit(RouteLoading());
      try {
        final steps = await getRouteUseCase(
          event.startLat,
          event.startLng,
          event.endLat,
          event.endLng,
        );
        emit(RouteLoaded(steps));
      } catch (e) {
        emit(RouteError("Error cargando la ruta"));
      }
    });
  }
}
