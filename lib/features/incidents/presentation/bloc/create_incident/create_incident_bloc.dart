import "package:ciudadano/features/incidents/domain/entities/create_incident.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/usecases/create_incident_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "create_incident_event.dart";
part "create_incident_state.dart";

class CreateIncidentBloc
    extends Bloc<CreateIncidentEvent, CreateIncidentState> {
  final CreateIncidentUseCase createIncident;

  CreateIncidentBloc(this.createIncident) : super(CreateIncidentInitial()) {
    on<CreateIncidentSubmit>(_onCreateIncident);
  }

  Future<void> _onCreateIncident(
    CreateIncidentSubmit event,
    Emitter<CreateIncidentState> emit,
  ) async {
    emit(CreateIncidentLoading());

    final result = await createIncident(event.incident);

    result.fold((failure) => emit(CreateIncidentError(failure)), (incident) {
      emit(CreateIncidentSuccess(incident));
    });
  }
}
