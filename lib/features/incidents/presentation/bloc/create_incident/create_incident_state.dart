part of "create_incident_bloc.dart";

abstract class CreateIncidentState extends Equatable {
  const CreateIncidentState();

  @override
  List<Object?> get props => [];
}

class CreateIncidentInitial extends CreateIncidentState {}

class CreateIncidentLoading extends CreateIncidentState {}

class CreateIncidentSuccess extends CreateIncidentState {
  final Incident incident;

  const CreateIncidentSuccess(this.incident);

  @override
  List<Object?> get props => [incident];
}

class CreateIncidentError extends CreateIncidentState {
  final String message;

  const CreateIncidentError(this.message);

  @override
  List<Object?> get props => [message];
}
