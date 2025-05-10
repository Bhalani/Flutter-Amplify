import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateProvider<bool>((ref) => false);

Future<void> signUpUser(WidgetRef ref, String email, String password,
    String firstName, String familyName) async {
  final authService = ref.read(authServiceProvider);
  try {
    await authService.signUp(email, password, firstName, familyName);
    ref.read(authStateProvider.notifier).state = true;
  } catch (e) {
    ref.read(authStateProvider.notifier).state = false;
    rethrow;
  }
}

Future<void> signInUser(WidgetRef ref, String email, String password) async {
  final authService = ref.read(authServiceProvider);
  try {
    await authService.signIn(email, password);
    ref.read(authStateProvider.notifier).state = true;
  } catch (e) {
    ref.read(authStateProvider.notifier).state = false;
    rethrow;
  }
}

Future<void> signOutUser(WidgetRef ref) async {
  final authService = ref.read(authServiceProvider);
  try {
    await authService.signOut();
    ref.read(authStateProvider.notifier).state = false;
  } catch (e) {
    rethrow;
  }
}
