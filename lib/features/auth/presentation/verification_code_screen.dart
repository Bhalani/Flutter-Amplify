import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
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
                      textAlign: TextAlign.center, // Center the input
                      validator: Validators.code,
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
                              // Only send user details to backend if coming from sign up
                              if (fromSignUp) {
                                try {
                                  final details =
                                      ref.read(signUpUserDetailsProvider);
                                  final firstName = details?.firstName ?? '';
                                  final lastName = details?.lastName ?? '';
                                  final emailVal = details?.email ?? email;
                                  debugPrint(
                                      "Sending detils to backend is being called");
                                  await sendUserDetailsToBackendProvider(
                                    ref,
                                    firstName: firstName,
                                    lastName: lastName,
                                    email: emailVal,
                                  );
                                  // Clear the provider after use
                                  ref
                                      .read(signUpUserDetailsProvider.notifier)
                                      .state = null;
                                } catch (e) {
                                  debugPrint(
                                      'Failed to send user details to backend: $e');
                                }
                              }
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
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {
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
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
