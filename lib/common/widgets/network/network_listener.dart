import "dart:async";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";

class NetworkListener extends StatefulWidget {
  final Widget child;

  const NetworkListener({super.key, required this.child});

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  late final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = true;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkInitialConnection();

    // Escucha cambios de conectividad
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = !results.contains(ConnectivityResult.none);
      _updateConnectionStatus(hasConnection);
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    final hasConnection = !results.contains(ConnectivityResult.none);
    _updateConnectionStatus(hasConnection);
  }

  void _updateConnectionStatus(bool connected) {
    if (mounted && connected != _isConnected) {
      setState(() => _isConnected = connected);

      if (!connected) {
        _showNoConnectionDialog();
      } else {
        if (_dialogShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context, rootNavigator: true).pop();
              _dialogShown = false;
            }
          });
        }
      }
    }
  }

  void _showNoConnectionDialog() {
    if (_dialogShown) {
      return;
    }
    _dialogShown = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            actionsPadding: const EdgeInsets.only(right: 16, bottom: 8),
            title: const Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.red, size: 28),
                SizedBox(width: 10),
                Text(
                  "Error de conexión",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: const Text(
              "No se ha podido contactar con el servidor.\n"
              "Comprueba tu conexión a internet.",
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final results = await _connectivity.checkConnectivity();
                  final hasConnection =
                      !results.contains(ConnectivityResult.none);
                  if (!mounted) {
                    return;
                  }
                  if (hasConnection) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context, rootNavigator: true).pop();
                    _dialogShown = false;
                  } else if (!_dialogShown) {
                    _dialogShown = true;
                    _showNoConnectionDialog();
                  }
                },
                child: const Text(
                  "REINTENTAR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
