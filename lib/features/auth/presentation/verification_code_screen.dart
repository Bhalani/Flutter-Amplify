import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/providers/auth_provider.dart';
import '../../shared/widgets/logo_widget.dart';

class VerificationCodeScreen extends ConsumerWidget {
  final String email;
  final bool fromSignUp;

  const VerificationCodeScreen(
      {required this.email, this.fromSignUp = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String confirmationCode = '';
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Align(
        alignment: const Alignment(0, -0.4),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'A confirmation code has been sent to $email. Please enter it below to verify your account.',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          getPlatformInputDecoration('Verification Code'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter the verification code'
                          : null,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!fromSignUp)
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.go('/verify_email');
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                textStyle: const TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Edit Email'),
                              ),
                            ),
                          ),
                        if (!fromSignUp) const SizedBox(width: 12),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              try {
                                await resendVerificationCode(ref, email);
                                showGentleSnackBar(
                                    context, 'Verification code sent!',
                                    type: SnackBarType.success);
                              } catch (e) {
                                showGentleSnackBar(context, 'Error: $e',
                                    type: SnackBarType.error);
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              textStyle: const TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text('Resend Code'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        context.go('/sign_up');
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
