import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:geolocator/geolocator.dart";
import "../bloc/alert_bloc.dart";
import "../bloc/alert_event.dart";
import "../bloc/alert_state.dart";

class EmergencyButton extends StatefulWidget {
  const EmergencyButton({super.key});

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with TickerProviderStateMixin {
  int _tapCount = 0;
  Timer? _tapTimer;
  bool _isActivated = false;
  late AnimationController _pulseController;
  late AnimationController _soundController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _soundController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // No verificamos alertas activas ya que no persisten en el backend
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    _pulseController.dispose();
    _soundController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isActivated) {
      // Si está activado, un solo tap lo desactiva
      _deactivateAlert();
      return;
    }

    // Lógica para activar con 3 taps
    _tapCount++;

    // Vibración corta en cada tap
    HapticFeedback.lightImpact();

    if (_tapCount == 1) {
      // Iniciar timer de 2 segundos para resetear el conteo
      _tapTimer?.cancel();
      _tapTimer = Timer(const Duration(seconds: 2), () {
        _tapCount = 0;
      });
    } else if (_tapCount == 3) {
      // Activar alerta con 3 taps
      _tapTimer?.cancel();
      _tapCount = 0;
      _activateAlert();
    }
  }

  Future<void> _activateAlert() async {
    try {
      // Vibración fuerte
      HapticFeedback.heavyImpact();

      // Obtener ubicación
      final position = await _getCurrentPosition();

      if (position != null) {
        // Activar sonido de alerta (simulación con vibración)
        _startAlertSound();

        // Enviar evento al bloc
        context.read<AlertBloc>().add(
          ActivateEmergencyAlert(
            latitude: position.latitude,
            longitude: position.longitude,
            address:
                "Ubicación de emergencia", // Puedes obtener la dirección real aquí
          ),
        );
      }
    } catch (e) {
      print("Error activando alerta: $e");
      _showErrorSnackBar("Error al activar la alerta de emergencia");
    }
  }

  void _deactivateAlert() {
    HapticFeedback.lightImpact();
    _stopAlertSound();
    context.read<AlertBloc>().add(DeactivateEmergencyAlert());
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar("Los servicios de ubicación están deshabilitados");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar("Los permisos de ubicación están denegados");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar(
          "Los permisos de ubicación están permanentemente denegados",
        );
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error obteniendo ubicación: $e");
      return null;
    }
  }

  void _startAlertSound() {
    // Simular sonido de alerta con vibraciones repetidas
    _pulseController.repeat(reverse: true);

    // Vibración periódica para simular sonido
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isActivated) {
        timer.cancel();
        return;
      }
      HapticFeedback.heavyImpact();
    });
  }

  void _stopAlertSound() {
    _pulseController.stop();
    _pulseController.reset();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlertBloc, AlertState>(
      listener: (context, state) {
        if (state is AlertActivated) {
          setState(() {
            _isActivated = true;
          });
          _showSuccessSnackBar("¡Alerta de emergencia activada!");
        } else if (state is AlertDeactivated) {
          setState(() {
            _isActivated = false;
          });
          _stopAlertSound();
          _showSuccessSnackBar("Alerta de emergencia desactivada");
        } else if (state is AlertError) {
          _showErrorSnackBar(state.message);
        }
      },
      child: Column(
        children: [
          // Botón de Emergencia
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isActivated ? _pulseAnimation.value : 1.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _handleTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isActivated ? Colors.red : Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            _isActivated
                                ? [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ]
                                : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isActivated ? Icons.warning : Icons.shield,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _isActivated
                                  ? "ALERTA ACTIVA - Toca para desactivar"
                                  : "Botón de Emergencia",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isActivated
                ? "Alerta enviada a las autoridades"
                : "Toca rápidamente 3 veces para activar",
            style: TextStyle(
              color: _isActivated ? Colors.red : Colors.black54,
              fontWeight: _isActivated ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }
}
