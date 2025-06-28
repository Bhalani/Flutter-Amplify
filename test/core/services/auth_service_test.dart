import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/core/services/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  test('signUp throws on invalid input', () async {
    final service = MockAuthService();
    when(service.signUp(
      any,
      any,
      any,
      any,
    )).thenThrow(Exception('error'));
    expect(() => service.signUp('bad', 'bad', 'bad', 'bad'), throwsException);
  });
}
