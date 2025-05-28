import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  LocalAuthentication get localAuth => _auth;

  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to sign in',
        options:
            const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'biometric_email', value: email);
    await _storage.write(key: 'biometric_password', value: password);
  }

  Future<Map<String, String?>> getCredentials() async {
    final email = await _storage.read(key: 'biometric_email');
    final password = await _storage.read(key: 'biometric_password');
    return {'email': email, 'password': password};
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: 'biometric_email');
    await _storage.delete(key: 'biometric_password');
  }
}
