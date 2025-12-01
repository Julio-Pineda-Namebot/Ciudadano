import "package:flutter_bloc/flutter_bloc.dart";
import "../../domain/entities/alert.dart";
import "../../domain/usecases/create_alert_use_case.dart";
import "alert_event.dart";
import "alert_state.dart";

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final CreateAlertUseCase createAlertUseCase;

  Alert? _currentActiveAlert;

  AlertBloc({required this.createAlertUseCase}) : super(AlertInitial()) {
    on<ActivateEmergencyAlert>(_onActivateEmergencyAlert);
    on<DeactivateEmergencyAlert>(_onDeactivateEmergencyAlert);
    on<CheckActiveAlert>(_onCheckActiveAlert);
  }

  Future<void> _onActivateEmergencyAlert(
    ActivateEmergencyAlert event,
    Emitter<AlertState> emit,
  ) async {
    emit(AlertLoading());

    try {
      final result = await createAlertUseCase(
        latitude: event.latitude,
        longitude: event.longitude,
        address: event.address,
        message: "Alerta de emergencia activada",
      );

      result.fold((error) => emit(AlertError(error)), (alert) {
        _currentActiveAlert = alert;
        emit(AlertActivated(alert));
      });
    } catch (e) {
      emit(AlertError("Error inesperado: $e"));
    }
  }

  Future<void> _onDeactivateEmergencyAlert(
    DeactivateEmergencyAlert event,
    Emitter<AlertState> emit,
  ) async {
    // Desactivar localmente sin petición al backend
    _currentActiveAlert = null;
    emit(AlertDeactivated());
  }

  Future<void> _onCheckActiveAlert(
    CheckActiveAlert event,
    Emitter<AlertState> emit,
  ) async {
    // Verificar estado local (no hay persistencia en backend)
    if (_currentActiveAlert != null) {
      emit(AlertActivated(_currentActiveAlert!));
    } else {
      emit(AlertDeactivated());
    }
  }

  bool get hasActiveAlert => _currentActiveAlert != null;
  Alert? get currentActiveAlert => _currentActiveAlert;
}
