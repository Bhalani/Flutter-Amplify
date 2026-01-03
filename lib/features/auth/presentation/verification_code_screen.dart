import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../shared/widgets/logo_widget.dart';

class VerificationCodeScreen extends ConsumerStatefulWidget {
  final String email;
  final bool fromSignUp;

  const VerificationCodeScreen(
      {required this.email, this.fromSignUp = false, super.key});

  @override
  ConsumerState<VerificationCodeScreen> createState() =>
      _VerificationCodeScreenState();
}

class _VerificationCodeScreenState
    extends ConsumerState<VerificationCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    codeController.dispose();
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
                  padding: const EdgeInsets.all(UIConstants.spaceMd), // 16dp
                  decoration: BoxDecoration(
                    color: UIConstants.primarySurfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_read_rounded,
                    size: 48,
                    color: UIConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: UIConstants.spaceMd), // 16dp
                Text(
                  'Verify Your Email',
                  style: UIConstants.headingStyle,
                ),
                const SizedBox(height: UIConstants.spaceSm), // 8dp
                Text(
                  'A code has been sent to',
                  style: UIConstants.captionStyle,
                ),
                Text(
                  widget.email,
                  style: TextStyle(
                    fontSize: UIConstants.normalTextSize,
                    fontWeight: FontWeight.w600,
                    color: UIConstants.primaryColor,
                  ),
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
                          controller: codeController,
                          decoration: const InputDecoration(
                            labelText: 'Verification Code',
                            prefixIcon: Icon(Icons.pin_outlined),
                            hintText: 'Enter 6-digit code',
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: 8,
                            fontWeight: FontWeight.w600,
                          ),
                          validator: Validators.code,
                          autofocus: true,
                        ),
                        const SizedBox(height: UIConstants.spaceLg), // 24dp
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleVerify,
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
                                : const Text('Verify'),
                          ),
                        ),
                        const SizedBox(height: UIConstants.spaceMd), // 16dp
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!widget.fromSignUp)
                              TextButton(
                                onPressed: () => context.go('/verify_email'),
                                child: const Text('Edit Email'),
                              ),
                            TextButton(
                              onPressed: _handleResend,
                              child: const Text('Resend Code'),
                            ),
                          ],
                        ),
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

  Future<void> _handleVerify() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        await confirmSignUp(ref, widget.email, codeController.text.trim());
        final isSignUpComplete = ref.read(authStateProvider).isSignUpComplete;
        final message = ref.read(authStateProvider).message;

        if (isSignUpComplete) {
          showGentleSnackBar(context, 'Email verified successfully!',
              type: SnackBarType.success);
          context.go('/home');
        } else {
          showGentleSnackBar(context, 'Error: $message',
              type: SnackBarType.error);
        }
      } catch (e) {
        showGentleSnackBar(context, 'Error: $e', type: SnackBarType.error);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleResend() async {
    try {
      await resendVerificationCode(ref, widget.email);
      showGentleSnackBar(context, 'Verification code sent!',
          type: SnackBarType.success);
    } catch (e) {
      showGentleSnackBar(context, 'Error: $e', type: SnackBarType.error);
    }
  }
}
