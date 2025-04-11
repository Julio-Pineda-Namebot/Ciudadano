import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();
  static final _logger = Logger();

  static Future<bool> canAuth() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      final isAuthAvailable = await canAuth();
      if (!isAuthAvailable) {
        _logger.w('Biometría no disponible en este dispositivo');
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Necesito tu confirmación biométrica',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      _logger.e('❌ Error durante la autenticación biométrica', error: e);
      return false;
    }
  }
}