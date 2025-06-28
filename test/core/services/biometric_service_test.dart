import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/core/services/biometric_service.dart';

void main() {
  test('BiometricService can be instantiated', () {
    final service = BiometricService();
    expect(service, isA<BiometricService>());
  });
}
