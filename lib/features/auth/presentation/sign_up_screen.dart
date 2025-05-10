import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/logo_widget.dart';
import '../../../core/providers/auth_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    bool acceptTerms = false;
    String email = ''; // Define the email variable

    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'First name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Family Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Family name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains('@')
                      ? 'Enter a valid email'
                      : null,
                  onSaved: (value) => email = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value == null || value.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (value) {
                        acceptTerms = value ?? false;
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to Terms and Conditions
                        },
                        child: const Text(
                          'I accept the Terms and Conditions and Privacy Policy',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();
                      if (!acceptTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You must accept the terms and conditions',
                            ),
                          ),
                        );
                        return;
                      }
                      try {
                        await signUpUser(
                          ref,
                          email,
                          password,
                          firstName,
                          familyName,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sign-up successful!')),
                        );
                        context.go('/sign_in');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Already have an account?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    context.go('/sign_in');
                  },
                  child: const Text('Sign In'),
                ),
                // const SizedBox(height: 16),
                // OutlinedButton(
                //   onPressed: () {
                //     if (Navigator.of(context).canPop()) {
                //       context.pop();
                //     } else {
                //       context.go('/');
                //     }
                //   },
                //   child: const Text('Back'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
