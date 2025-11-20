part of "report_incident_bloc.dart";

abstract class ReportIncidentEvent extends Equatable {
  const ReportIncidentEvent();

  @override
  List<Object?> get props => [];
}

class ReportIncidentSubmit extends ReportIncidentEvent {
  final ReportIncident incident;

  const ReportIncidentSubmit(this.incident);

  @override
  List<Object?> get props => [incident];
}
