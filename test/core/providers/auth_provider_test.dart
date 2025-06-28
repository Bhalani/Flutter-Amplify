import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/core/providers/auth_provider.dart';
import 'package:amplify_auth/core/services/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  test('userEmailProvider initializes with null or saved value', () async {
    final container = ProviderContainer();
    final email = container.read(userEmailProvider);
    expect(email, anyOf([null, isA<String>()]));
  });

  test('authStateProvider initial state', () {
    final container = ProviderContainer();
    final state = container.read(authStateProvider);
    expect(state.isSignedIn, false);
    expect(state.isSignUpComplete, false);
    expect(state.isConfirming, false);
    expect(state.message, '');
  });
}
