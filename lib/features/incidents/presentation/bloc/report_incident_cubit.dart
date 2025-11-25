import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/params/report_incident_param.dart";
import "package:ciudadano/features/incidents/domain/usecases/report_incident_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class ReportIncidentState extends Equatable {
  const ReportIncidentState();
}

class ReportIncidentInitialState extends ReportIncidentState {
  const ReportIncidentInitialState();

  @override
  List<Object?> get props => [];
}

class ReportIncidentLoadingState extends ReportIncidentState {
  const ReportIncidentLoadingState();

  @override
  List<Object?> get props => [];
}

class ReportIncidentSuccessState extends ReportIncidentState {
  final Incident incidentCreated;

  const ReportIncidentSuccessState(this.incidentCreated);

  @override
  List<Object?> get props => [incidentCreated];
}

class ReportIncidentErrorState extends ReportIncidentState {
  final String message;

  const ReportIncidentErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class ReportIncidentCubit extends Cubit<ReportIncidentState> {
  final ReportIncidentUseCase _reportIncidentUseCase;

  ReportIncidentCubit(this._reportIncidentUseCase)
    : super(const ReportIncidentInitialState());

  Future<void> reportIncident(ReportIncidentParam reportIncidentParam) async {
    emit(const ReportIncidentLoadingState());

    final either = await _reportIncidentUseCase(reportIncidentParam);

    either.fold(
      (message) => emit(ReportIncidentErrorState(message)),
      (incidentCreated) => emit(ReportIncidentSuccessState(incidentCreated)),
    );
  }
}
