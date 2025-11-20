import "package:ciudadano/features/incidents/domain/entities/report_incident.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/usecases/report_incident_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "report_incident_event.dart";
part "report_incident_state.dart";

class ReportIncidentBloc
    extends Bloc<ReportIncidentEvent, ReportIncidentState> {
  final ReportIncidentUseCase reportIncident;

  ReportIncidentBloc(this.reportIncident) : super(ReportIncidentInitial()) {
    on<ReportIncidentSubmit>(_onReportIncident);
  }

  Future<void> _onReportIncident(
    ReportIncidentSubmit event,
    Emitter<ReportIncidentState> emit,
  ) async {
    emit(ReportIncidentLoading());

    final result = await reportIncident(event.incident);

    result.fold((failure) => emit(ReportIncidentError(failure)), (incident) {
      emit(ReportIncidentSuccess(incident));
    });
  }
}
