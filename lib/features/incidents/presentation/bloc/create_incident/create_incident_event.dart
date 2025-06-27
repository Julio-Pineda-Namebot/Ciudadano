part of "create_incident_bloc.dart";

abstract class CreateIncidentEvent extends Equatable {
  const CreateIncidentEvent();

  @override
  List<Object?> get props => [];
}

class CreateIncidentSubmit extends CreateIncidentEvent {
  final CreateIncident incident;

  const CreateIncidentSubmit(this.incident);

  @override
  List<Object?> get props => [incident];
}
