import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../shared/widgets/logo_widget.dart';
import 'package:amplify_auth/main.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  bool _obscurePassword = true;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ref.watch(userEmailProvider);
    if (userEmail != null && emailController.text.isEmpty) {
      emailController.text = userEmail;
    }

    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spaceMd, // 16dp M3 standard
                  vertical: UIConstants.spaceLg, // 24dp M3 standard
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Text(
                      'Welcome Back',
                      style: UIConstants.headingStyle,
                    ),
                    const SizedBox(height: UIConstants.spaceSm), // 8dp
                    Text(
                      'Sign in to continue to your account',
                      style: UIConstants.captionStyle,
                    ),

                    const SizedBox(height: UIConstants.spaceLg), // 24dp

                    // Form Card
                    Container(
                      padding:
                          const EdgeInsets.all(UIConstants.spaceMd), // 16dp
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
                              onSaved: (value) => email = value ?? '',
                              enabled: !isLoading,
                            ),
                            const SizedBox(height: UIConstants.spaceMd), // 16dp
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) =>
                                  value == null || value.length < 6
                                      ? 'Password must be at least 6 characters'
                                      : null,
                              onSaved: (value) => password = value ?? '',
                              enabled: !isLoading,
                            ),
                            const SizedBox(height: UIConstants.spaceSm), // 8dp
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () => context.go('/forgot_password'),
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                            const SizedBox(height: UIConstants.spaceLg), // 24dp
                            // Primary action button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          formKey.currentState?.save();
                                          setState(() => isLoading = true);
                                          try {
                                            final currentEmail =
                                                emailController.text.trim();
                                            await signInUser(
                                                ref, currentEmail, password);
                                            if (ref
                                                .read(authStateProvider)
                                                .isSignedIn) {
                                              context.go('/home');
                                              showGentleSnackBar(
                                                context,
                                                ref
                                                    .read(authStateProvider)
                                                    .message,
                                                type: SnackBarType.success,
                                              );
                                            } else {
                                              showGentleSnackBar(
                                                context,
                                                ref
                                                    .read(authStateProvider)
                                                    .message,
                                                type: SnackBarType.error,
                                              );
                                            }
                                          } catch (e) {
                                            showGentleSnackBar(
                                              context,
                                              ref
                                                  .read(authStateProvider)
                                                  .message,
                                              type: SnackBarType.error,
                                            );
                                          } finally {
                                            setState(() => isLoading = false);
                                          }
                                        }
                                      },
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text('Sign In'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: UIConstants.spaceXl), // 32dp

                    // Sign up section
                    Text(
                      "Don't have an account?",
                      style: UIConstants.bodyStyle,
                    ),
                    const SizedBox(height: UIConstants.spaceSm), // 8dp
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed:
                            isLoading ? null : () => context.go('/sign_up'),
                        child: const Text('Create Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.05),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
