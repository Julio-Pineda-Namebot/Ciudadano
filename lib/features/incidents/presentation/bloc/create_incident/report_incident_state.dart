part of "report_incident_bloc.dart";

abstract class ReportIncidentState extends Equatable {
  const ReportIncidentState();

  @override
  List<Object?> get props => [];
}

class ReportIncidentInitial extends ReportIncidentState {}

class ReportIncidentLoading extends ReportIncidentState {}

class ReportIncidentSuccess extends ReportIncidentState {
  final Incident incident;

  const ReportIncidentSuccess(this.incident);

  @override
  List<Object?> get props => [incident];
}

class ReportIncidentError extends ReportIncidentState {
  final String message;

  const ReportIncidentError(this.message);

  @override
  List<Object?> get props => [message];
}
