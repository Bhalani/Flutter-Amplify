import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Color _getStrengthColor(double strength) {
    if (strength < 0.4) return UIConstants.dangerColor;
    if (strength < 0.8) return UIConstants.warningColor;
    return UIConstants.successColor;
  }

  String _getStrengthLabel(double strength) {
    if (strength < 0.4) return 'Weak';
    if (strength < 0.8) return 'Medium';
    return 'Strong';
  }

  Future<void> _sendCode() async {
    setState(() => isLoading = true);
    try {
      final result = await ref
          .read(authServiceProvider)
          .resetPassword(_emailController.text.trim());
      final nextStep = result.nextStep.updateStep;
      if (nextStep == AuthResetPasswordStep.confirmResetPasswordWithCode) {
        setState(() => codeSent = true);
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
    final strength = Validators.passwordStrength(_passwordController.text);
    final strengthColor = _getStrengthColor(strength);
    final strengthLabel = _getStrengthLabel(strength);

    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/sign_in');
            }
          },
        ),
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
                // Header
                Container(
                  padding: const EdgeInsets.all(UIConstants.spaceMd), // 16dp
                  decoration: BoxDecoration(
                    color: UIConstants.primarySurfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    codeSent
                        ? Icons.lock_reset_rounded
                        : Icons.lock_outline_rounded,
                    size: 48,
                    color: UIConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: UIConstants.spaceMd), // 16dp
                Text(
                  codeSent ? 'Reset Password' : 'Forgot Password',
                  style: UIConstants.headingStyle,
                ),
                const SizedBox(height: UIConstants.spaceSm), // 8dp
                Text(
                  codeSent
                      ? 'Enter the code sent to your email'
                      : 'Enter your email to receive a reset code',
                  style: UIConstants.captionStyle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: UIConstants.spaceLg), // 24dp

                // Form Card
                Container(
                  padding: const EdgeInsets.all(UIConstants.spaceMd), // 16dp
                  decoration: UIConstants.cardDecoration,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                          enabled: !codeSent,
                        ),
                        if (codeSent) ...[
                          const SizedBox(height: UIConstants.spaceMd), // 16dp
                          TextFormField(
                            controller: _codeController,
                            decoration: const InputDecoration(
                              labelText: 'Verification Code',
                              prefixIcon: Icon(Icons.pin_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            validator: Validators.code,
                          ),
                          const SizedBox(height: UIConstants.spaceMd), // 16dp
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() =>
                                      _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: Validators.password,
                            onChanged: (value) => setState(() {}),
                          ),
                          const SizedBox(height: UIConstants.spaceSm), // 8dp
                          ClipRRect(
                            borderRadius: UIConstants.borderRadiusXs,
                            child: LinearProgressIndicator(
                              value: strength,
                              backgroundColor: UIConstants.dividerColor,
                              color: strengthColor,
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: UIConstants.spaceXs), // 4dp
                          Text(
                            'Password strength: $strengthLabel',
                            style: TextStyle(
                              color: strengthColor,
                              fontSize: UIConstants.tinyTextSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: UIConstants.spaceMd), // 16dp
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() => _obscureConfirmPassword =
                                      !_obscureConfirmPassword);
                                },
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
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
                        const SizedBox(height: UIConstants.spaceLg), // 24dp
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
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
                                : Text(
                                    codeSent ? 'Reset Password' : 'Send Code'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
