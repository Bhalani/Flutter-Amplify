import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if (userEmail != null && userEmail != emailController.text) {
      emailController.text = userEmail;
    }
    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: getPlatformInputDecoration('Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      onSaved: (value) => email = value ?? '',
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: getPlatformInputDecoration('Password'),
                      obscureText: true,
                      validator: (value) => value == null || value.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                      onSaved: (value) => password = value ?? '',
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.only(right: 5),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.go('/forgot_password');
                                },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (formKey.currentState?.validate() ?? false) {
                                formKey.currentState?.save();
                                setState(() => isLoading = true);
                                try {
                                  await signInUser(
                                    ref,
                                    email,
                                    password,
                                  );
                                  if (ref.read(authStateProvider).isSignedIn) {
                                    context.go('/home');
                                    showGentleSnackBar(context,
                                        ref.read(authStateProvider).message,
                                        type: SnackBarType.success);
                                  } else {
                                    showGentleSnackBar(context,
                                        ref.read(authStateProvider).message,
                                        type: SnackBarType.error);
                                  }
                                } catch (e) {
                                  showGentleSnackBar(context,
                                      ref.read(authStateProvider).message,
                                      type: SnackBarType.error);
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
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Sign In'),
                    ),
                    const SizedBox(height: 32),
                    Text("Don't have an account?"),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.go('/sign_up');
                            },
                      child: const Text('Sign Up'),
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
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
