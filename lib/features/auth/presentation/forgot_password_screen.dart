import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/providers/auth_provider.dart';
import '../../shared/widgets/logo_widget.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool codeSent = false;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    setState(() => isLoading = true);
    try {
      final result = await ref
          .read(authServiceProvider)
          .resetPassword(_emailController.text.trim());
      final nextStep = result.nextStep.updateStep;
      if (nextStep == AuthResetPasswordStep.confirmResetPasswordWithCode) {
        setState(() {
          codeSent = true;
        });
        showGentleSnackBar(context, 'Verification code sent to your email.',
            type: SnackBarType.info);
      } else if (result.isPasswordReset) {
        showGentleSnackBar(context, 'Password reset. Please sign in.',
            type: SnackBarType.success);
        context.go('/sign_in');
      } else {
        showGentleSnackBar(context, 'Unexpected next step: $nextStep',
            type: SnackBarType.info);
      }
    } catch (e) {
      showGentleSnackBar(context, e.toString(), type: SnackBarType.error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _confirmReset() async {
    setState(() => isLoading = true);
    try {
      final result = await ref.read(authServiceProvider).confirmResetPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _codeController.text.trim(),
          );
      debugPrint('Result: ${result.isPasswordReset}');
      if (result.isPasswordReset) {
        showGentleSnackBar(
            context, 'Password reset successful! Please sign in.',
            type: SnackBarType.success);
        context.go('/sign_in');
      } else {
        showGentleSnackBar(context, 'Password reset failed. Please try again.',
            type: SnackBarType.error);
      }
    } catch (e) {
      showGentleSnackBar(context, e.toString(), type: SnackBarType.error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/sign_in');
            }
          },
          tooltip: 'Back',
        ),
        title: const LogoWidget(),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 44),
                TextFormField(
                  controller: _emailController,
                  decoration: getPlatformInputDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains('@')
                      ? 'Enter a valid email'
                      : null,
                  enabled: !codeSent,
                ),
                if (codeSent) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeController,
                    decoration: getPlatformInputDecoration('Verification Code'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter the code sent to your email'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: getPlatformInputDecoration('New Password'),
                    obscureText: true,
                    validator: (value) => value == null || value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: getPlatformInputDecoration('Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (codeSent &&
                                _passwordController.text !=
                                    _confirmPasswordController.text) {
                              showGentleSnackBar(
                                  context, 'Passwords do not match',
                                  type: SnackBarType.error);
                              return;
                            }
                            if (!codeSent) {
                              await _sendCode();
                            } else {
                              await _confirmReset();
                            }
                          }
                        },
                        child: Text(codeSent ? 'Reset Password' : 'Send Code'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
