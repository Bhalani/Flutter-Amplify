import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/providers/auth_provider.dart';

class VerificationCodeScreen extends ConsumerWidget {
  final String email;

  const VerificationCodeScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String confirmationCode = '';
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'A confirmation code has been sent to $email. Please enter it below to verify your account.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Confirmation Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
                onSaved: (value) => confirmationCode = value ?? '',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    try {
                      await confirmSignUp(
                        ref,
                        email,
                        confirmationCode.trim(),
                      );

                      final isSignUpComplete =
                          ref.read(authStateProvider).isSignUpComplete;
                      final message = ref.read(authStateProvider).message;

                      if (isSignUpComplete) {
                        showGentleSnackBar(
                            context, 'Email verified successfully!',
                            type: SnackBarType.success);
                        context.go('/home');
                      } else {
                        showGentleSnackBar(context, 'Error: $message',
                            type: SnackBarType.error);
                      }
                    } catch (e) {
                      showGentleSnackBar(context, 'Error: $e',
                          type: SnackBarType.error);
                    }
                  }
                },
                child: const Text('Verify'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  try {
                    await resendVerificationCode(ref, email);
                    showGentleSnackBar(context, 'Verification code resent!',
                        type: SnackBarType.info);
                  } catch (e) {
                    showGentleSnackBar(context, 'Error: $e',
                        type: SnackBarType.error);
                  }
                },
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
