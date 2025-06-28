import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../shared/widgets/logo_widget.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final showLoginButton = ValueNotifier(false);

    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
      ),
      body: Align(
        alignment: const Alignment(0, -0.4),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text('Verify Email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: getPlatformInputDecoration('Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          final email = emailController.text.trim();
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
                              context.go('/code_verification',
                                  extra: {'email': email, 'fromSignUp': false});
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/sign_up');
                  },
                  child: const Text('Back to Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
