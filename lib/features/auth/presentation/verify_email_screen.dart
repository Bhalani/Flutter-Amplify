import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String email = '';
    final formKey = GlobalKey<FormState>();
    final showLoginButton = ValueNotifier(false);

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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
                onSaved: (value) => email = value ?? '',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    if (email.isEmpty) {
                      showGentleSnackBar(
                        context,
                        'Please enter your email.',
                        type: SnackBarType.error,
                      );
                      return;
                    }
                    try {
                      await resendVerificationCode(ref, email);
                      if (ref.read(authStateProvider).isConfirming) {
                        showGentleSnackBar(
                          context,
                          'Verification code sent!',
                          type: SnackBarType.success,
                        );
                        context
                            .go('/verification_code', extra: {'email': email});
                      } else {
                        showLoginButton.value = true;
                        showGentleSnackBar(
                          context,
                          ref.read(authStateProvider).message,
                          type: SnackBarType.info,
                        );
                      }
                    } catch (e) {
                      showGentleSnackBar(
                        context,
                        'Error: $e',
                        type: SnackBarType.error,
                      );
                    }
                  }
                },
                child: const Text('Send Verification Code'),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: showLoginButton,
                builder: (context, value, child) {
                  if (!value) return const SizedBox.shrink();
                  return ElevatedButton(
                    onPressed: () {
                      context.go('/sign_in');
                    },
                    child: const Text('Go to Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
