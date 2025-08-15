import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final biometricServiceProvider =
    Provider<BiometricService>((ref) => BiometricService());

final authStateProvider =
    StateProvider<AuthState>((ref) => AuthState.initial());

final userEmailProvider = StateNotifierProvider<UserEmailNotifier, String?>(
    (ref) => UserEmailNotifier());
final signUpUserDetailsProvider =
    StateProvider<({String firstName, String lastName, String email})?>(
        (ref) => null);

class UserEmailNotifier extends StateNotifier<String?> {
  UserEmailNotifier() : super(null) {
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('user_email');
  }

  Future<void> setEmail(String? email) async {
    final prefs = await SharedPreferences.getInstance();
    if (email != null && email.isNotEmpty) {
      await prefs.setString('user_email', email);
      state = email;
    } else {
      await prefs.remove('user_email');
      state = null;
    }
  }
}

class AuthState {
  final bool isSignedIn;
  final bool isSignUpComplete;
  final bool isConfirming;
  final String message;

  const AuthState({
    required this.isSignedIn,
    required this.isSignUpComplete,
    required this.isConfirming,
    required this.message,
  });

  factory AuthState.initial() {
    return const AuthState(
      isSignedIn: false,
      isSignUpComplete: false,
      isConfirming: false,
      message: '',
    );
  }
}

Future<void> signUpUser(WidgetRef ref, BuildContext context, String email,
    String password, String firstName, String familyName) async {
  final authService = ref.read(authServiceProvider);
  try {
    final result =
        await authService.signUp(email, password, firstName, familyName);
    await ref.read(userEmailProvider.notifier).setEmail(email);
    // Store user details for later use in verification
    ref.read(signUpUserDetailsProvider.notifier).state = (
      firstName: firstName,
      lastName: familyName,
      email: email,
    );

    print('result: $result');
    print('result.nextStep: ${result.nextStep}');
    print('result.nextStep.signUpStep: ${result.nextStep.signUpStep}');
    if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
      ref.read(authStateProvider.notifier).state = AuthState(
        isSignedIn: false,
        isSignUpComplete: false,
        isConfirming: true,
        message: 'Sign-up successful! Please confirm your email.',
      );
    } else {
      ref.read(authStateProvider.notifier).state = AuthState(
        isSignedIn: false,
        isSignUpComplete: false,
        isConfirming: false,
        message: 'Unexpected sign-up step: ${result.nextStep.signUpStep}',
      );
    }
  } catch (e) {
    // Try to extract a meaningful message from the exception string
    String errorMsg = e.toString();
    final messageMatch = RegExp(r'"message":\s*"([^"]+)"').firstMatch(errorMsg);
    if (messageMatch != null) {
      errorMsg = messageMatch.group(1)!;
    } else {
      // Fallback: remove 'Exception: ' prefix if present
      errorMsg = errorMsg.replaceFirst(RegExp(r'^Exception: '), '');
    }
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: false,
      isSignUpComplete: false,
      isConfirming: false,
      message: errorMsg,
    );
  }
}

Future<void> confirmSignUp(
    WidgetRef ref, String email, String confirmationCode) async {
  final authService = ref.read(authServiceProvider);
  try {
    final result = await authService.confirmSignUp(email, confirmationCode);
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: false,
      isSignUpComplete: result.isSignUpComplete,
      isConfirming: !result.isSignUpComplete,
      message: result.isSignUpComplete
          ? 'Confirmation successful! Please sign in.'
          : 'Confirmation incomplete. Try again.',
    );
    print('Confirmation result: $result');
  } catch (e) {
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: false,
      isSignUpComplete: false,
      isConfirming: true,
      message: 'Invalid confirmation code. Please try again.',
    );
  }
}

Future<void> signInUser(WidgetRef ref, String email, String password) async {
  final authService = ref.read(authServiceProvider);
  debugPrint('Signing in with email: $email');
  try {
    final result = await authService.signIn(email, password);
    await ref.read(userEmailProvider.notifier).setEmail(email);
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: result.isSignedIn,
      isSignUpComplete: true,
      isConfirming: false,
      message: result.isSignedIn ? 'Sign-in successful!' : 'Sign-in failed.',
    );
  } catch (e) {
    String errorMsg = e.toString();
    final messageMatch = RegExp(r'"message":\s*"([^"]+)"').firstMatch(errorMsg);
    if (messageMatch != null) {
      errorMsg = messageMatch.group(1)!;
    } else {
      errorMsg = errorMsg.replaceFirst(RegExp(r'^Exception: '), '');
    }

    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: false,
      isSignUpComplete: true,
      isConfirming: false,
      message: errorMsg,
    );
    rethrow;
  }
}

Future<void> signOutUser(WidgetRef ref) async {
  final authService = ref.read(authServiceProvider);
  try {
    await authService.signOut();
    ref.read(authStateProvider.notifier).state = AuthState.initial();
  } catch (e) {
    rethrow;
  }
}

Future<void> resendVerificationCode(WidgetRef ref, String email) async {
  final authService = ref.read(authServiceProvider);
  debugPrint("\n\n\n\n\n Hey hey hey hey hey \n\n\n\n");
  try {
    await authService.resendVerificationCode(email);
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: false,
      isSignUpComplete: false,
      isConfirming: true,
      message: 'Verification code resent successfully!',
    );
  } catch (e) {
    String errorMsg = e.toString();
    final messageMatch = RegExp(r'"message":\s*"([^"]+)"').firstMatch(errorMsg);
    if (messageMatch != null) {
      errorMsg = messageMatch.group(1)!;
    } else {
      // Fallback: remove 'Exception: ' prefix if present
      errorMsg = errorMsg.replaceFirst(RegExp(r'^Exception: '), '');
    }
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: false,
      isSignUpComplete: false,
      isConfirming: false,
      message: errorMsg,
    );
  }
}

Future<void> updatePasswordProvider(
  WidgetRef ref,
  String oldPassword,
  String newPassword,
) async {
  final authService = ref.read(authServiceProvider);
  try {
    await authService.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: true,
      isSignUpComplete: true,
      isConfirming: false,
      message: 'Password updated successfully!',
    );
  } on AuthException catch (e) {
    ref.read(authStateProvider.notifier).state = AuthState(
      isSignedIn: true,
      isSignUpComplete: true,
      isConfirming: false,
      message: e.message,
    );
    rethrow;
  }
}

// Future<void> sendUserDetailsToBackendProvider(
//   WidgetRef ref, {
//   required String firstName,
//   required String lastName,
//   required String email,
// }) async {
//   final authService = ref.read(authServiceProvider);
//   await authService.sendUserDetailsToBackend(
//     firstName: firstName,
//     lastName: lastName,
//     email: email,
//   );
// }
