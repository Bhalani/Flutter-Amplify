import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../shared/widgets/logo_widget.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showLoginButton = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.spaceMd, // 16dp
              vertical: UIConstants.spaceLg, // 24dp
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Icon
                Container(
                  padding: const EdgeInsets.all(UIConstants.spaceMd),
                  decoration: BoxDecoration(
                    color: UIConstants.primarySurfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 48,
                    color: UIConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: UIConstants.spaceMd), // 16dp
                Text(
                  'Verify Email',
                  style: UIConstants.headingStyle,
                ),
                const SizedBox(height: UIConstants.spaceSm), // 8dp
                Text(
                  'Enter your email to receive a verification code',
                  style: UIConstants.captionStyle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: UIConstants.spaceLg), // 24dp

                // Form Card
                Container(
                  padding: const EdgeInsets.all(UIConstants.spaceMd), // 16dp
                  decoration: UIConstants.cardDecoration,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),
                        const SizedBox(height: UIConstants.spaceLg), // 24dp
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleSendCode,
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text('Send Verification Code'),
                          ),
                        ),
                        if (showLoginButton) ...[
                          const SizedBox(height: UIConstants.spaceMd), // 16dp
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => context.go('/sign_in'),
                              child: const Text('Go to Login'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: UIConstants.spaceXl), // 32dp

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/sign_up'),
                    child: const Text('Back to Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSendCode() async {
    if (formKey.currentState?.validate() ?? false) {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        showGentleSnackBar(context, 'Please enter your email.',
            type: SnackBarType.error);
        return;
      }
      setState(() => isLoading = true);
      try {
        await resendVerificationCode(ref, email);
        if (ref.read(authStateProvider).isConfirming) {
          showGentleSnackBar(context, 'Verification code sent!',
              type: SnackBarType.success);
          context.go('/code_verification',
              extra: {'email': email, 'fromSignUp': false});
        } else {
          setState(() => showLoginButton = true);
          showGentleSnackBar(context, ref.read(authStateProvider).message,
              type: SnackBarType.info);
        }
      } catch (e) {
        showGentleSnackBar(context, 'Error: $e', type: SnackBarType.error);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}
