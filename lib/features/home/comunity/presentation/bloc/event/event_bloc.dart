import "package:ciudadano/features/home/comunity/domain/entities/event.dart";
import "package:ciudadano/features/home/comunity/domain/usecases/event/add_event.dart";
import "package:ciudadano/features/home/comunity/domain/usecases/event/get_event.dart";
import "package:ciudadano/features/home/comunity/domain/usecases/event/toggle_join_event.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_event.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class EventoBloc extends Bloc<EventoEvent, EventoState> {
  final GetEventos getEventos;
  final AddEvento addEvento;
  final ToggleJoinEvento toggleJoin;

  EventoBloc({
    required this.getEventos,
    required this.addEvento,
    required this.toggleJoin,
  }) : super(EventoInitial()) {
    on<CargarEventos>(_onLoad);
    on<CrearEvento>(_onCreate);
    on<UnirseEvento>(_onJoin);
  }

  Future<void> _onLoad(CargarEventos e, Emitter emit) async {
    emit(EventoLoading());
    try {
      emit(EventoLoaded(await getEventos()));
    } catch (_) {
      emit(const EventoError("Error cargando eventos"));
    }
  }

  Future<void> _onCreate(CrearEvento e, Emitter emit) async {
    final nuevo = Evento(
      id: DateTime.now().microsecondsSinceEpoch, // id simple
      nombre: e.nombre,
      fecha: e.fecha,
      joined: false,
    );
    await addEvento(nuevo);
    emit(EventoLoaded(await getEventos()));
  }

  Future<void> _onJoin(UnirseEvento e, Emitter emit) async {
    await toggleJoin(e.id);
    emit(EventoLoaded(await getEventos()));
  }
}
