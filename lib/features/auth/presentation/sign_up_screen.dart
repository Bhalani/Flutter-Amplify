import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/ui_constants.dart';
import '../../shared/widgets/logo_widget.dart';
import '../../../core/providers/auth_provider.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/utils/validators.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  bool acceptTerms = false;
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String email = '';
  String password = '';
  String firstName = '';
  String familyName = '';
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final strength = Validators.passwordStrength(passwordController.text);
    final strengthColor = _getStrengthColor(strength);
    final strengthLabel = _getStrengthLabel(strength);

    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spaceMd, // 16dp
            vertical: UIConstants.spaceLg, // 24dp
          ),
          child: Column(
            children: [
              // Header
              Text(
                'Create Account',
                style: UIConstants.headingStyle,
              ),
              const SizedBox(height: UIConstants.spaceSm), // 8dp
              Text(
                'Sign up to get started',
                style: UIConstants.captionStyle,
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
                      // Name Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (value) =>
                                  Validators.name(value, field: 'First name'),
                              onSaved: (value) => firstName = value ?? '',
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          const SizedBox(width: UIConstants.spaceMd), // 16dp
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                              ),
                              validator: (value) =>
                                  Validators.name(value, field: 'Last name'),
                              onSaved: (value) => familyName = value ?? '',
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: UIConstants.spaceMd), // 16dp
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        onSaved: (value) => email = value ?? '',
                      ),
                      const SizedBox(height: UIConstants.spaceMd), // 16dp
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: Validators.password,
                        onChanged: (value) {
                          password = value;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: UIConstants.spaceSm), // 8dp
                      // Password strength indicator
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
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: UIConstants.spaceMd), // 16dp
                      // Terms checkbox
                      Container(
                        padding:
                            const EdgeInsets.all(UIConstants.spaceSm), // 8dp
                        decoration: BoxDecoration(
                          color: UIConstants.backgroundColor,
                          borderRadius: UIConstants.borderRadiusSm,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: acceptTerms,
                              onChanged: (value) {
                                setState(() => acceptTerms = value ?? false);
                              },
                              activeColor: UIConstants.primaryColor,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showTermsDialog(context),
                                child: Text(
                                  'I accept the Terms and Conditions',
                                  style: TextStyle(
                                    color: UIConstants.primaryColor,
                                    fontSize: UIConstants.smallTextSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: UIConstants.spaceMd), // 16dp
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSignUp,
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
                              : const Text('Create Account'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: UIConstants.spaceXl), // 32dp

              // Sign in section
              Text(
                'Already have an account?',
                style: UIConstants.bodyStyle,
              ),
              const SizedBox(height: UIConstants.spaceSm), // 8dp
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/sign_in'),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: UIConstants.spaceSm),
              TextButton(
                onPressed: () => context.go('/verify_email'),
                child: Text(
                  'Verify Email',
                  style: TextStyle(
                    color: UIConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      if (!acceptTerms) {
        showGentleSnackBar(
          context,
          'You must accept the terms and conditions',
          type: SnackBarType.error,
        );
        return;
      }
      setState(() => isLoading = true);
      try {
        await signUpUser(ref, context, email, password, firstName, familyName);
        if (ref.read(authStateProvider).isConfirming) {
          context.go('/code_verification',
              extra: {'email': email, 'fromSignUp': true});
        } else {
          showGentleSnackBar(
            context,
            ref.read(authStateProvider).message,
            type: SnackBarType.info,
          );
        }
      } catch (e) {
        showGentleSnackBar(context, 'Error: $e', type: SnackBarType.error);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: UIConstants.borderRadiusLg),
        title: Text('Terms and Conditions', style: UIConstants.titleStyle),
        content: SingleChildScrollView(
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
            'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            style: UIConstants.bodyStyle,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
