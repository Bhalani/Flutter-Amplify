import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/logo_widget.dart';
import '../../../core/providers/auth_provider.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/utils/validators.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    bool acceptTerms = false;
    String email = ''; // Define the email variable
    String password = ''; // Define the password variable
    String firstName = ''; // Define the firstName variable
    String familyName = ''; // Define the familyName variable
    final passwordController = TextEditingController();

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
                      'Create Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: getPlatformInputDecoration('First Name'),
                      validator: (value) =>
                          Validators.name(value, field: 'First name'),
                      onSaved: (value) => firstName = value ?? '',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: getPlatformInputDecoration('Family Name'),
                      validator: (value) =>
                          Validators.name(value, field: 'Family name'),
                      onSaved: (value) => familyName = value ?? '',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: getPlatformInputDecoration('Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      onSaved: (value) => email = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    StatefulBuilder(
                      builder: (context, setState) {
                        double strength = Validators.passwordStrength(
                            passwordController.text);
                        Color strengthColor;
                        String strengthLabel;
                        if (strength < 0.4) {
                          strengthColor = Colors.red;
                          strengthLabel = 'Weak';
                        } else if (strength < 0.8) {
                          strengthColor = Colors.orange;
                          strengthLabel = 'Medium';
                        } else {
                          strengthColor = Colors.green;
                          strengthLabel = 'Strong';
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: passwordController,
                              decoration:
                                  getPlatformInputDecoration('Password'),
                              obscureText: true,
                              validator: Validators.password,
                              onChanged: (value) {
                                password = value;
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: strength,
                              backgroundColor: Colors.grey[300],
                              color: strengthColor,
                              minHeight: 5,
                            ),
                            Text('Password strength: $strengthLabel',
                                style: TextStyle(
                                    color: strengthColor, fontSize: 12)),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          getPlatformInputDecoration('Confirm Password'),
                      obscureText: true,
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Checkbox(
                              value: acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  acceptTerms = value ?? false;
                                });
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Terms and Conditions'),
                                    content: SingleChildScrollView(
                                      child: Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n'
                                        'Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam lacus eget erat. Cras mollis scelerisque nunc. Nullam arcu. Aliquam consequat. Curabitur augue lorem, dapibus quis, laoreet et, pretium ac, nisi. Aenean magna nisl, mollis quis, molestie eu, feugiat in, orci. In hac habitasse platea dictumst.\n\n'
                                        'Fusce convallis, mauris imperdiet gravida bibendum, nisl turpis suscipit mauris, sed placerat ipsum urna sed risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Nulla facilisi. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin at libero id massa vulputate tincidunt. Vivamus quis mi. Phasellus a est. Phasellus magna. In hac habitasse platea dictumst. Curabitur at lacus ac velit ornare lobortis. Curabitur a felis in nunc fringilla tristique.\n\n'
                                        'Morbi mollis tellus ac sapien. Phasellus at dui in ligula mollis ultricies. Integer placerat tristique nisl. Praesent augue. Fusce commodo aliquam arcu. Nam commodo suscipit quam. Sed a libero. Pellentesque egestas, neque sit amet convallis pulvinar, justo nulla eleifend augue, ac auctor orci leo non est. Ut leo. Ut a nisl id ante tempus hendrerit. Curabitur nisi. Quisque malesuada placerat nisl. Nam ipsum risus, rutrum vitae, vestibulum eu, molestie vel, lacus. Sed lectus. Praesent elementum hendrerit tortor. Sed semper lorem at felis. Vestibulum volutpat, lacus a ultrices sagittis, mi neque euismod dui, eu pulvinar nunc sapien ornare nisl. Phasellus pede arcu, dapibus eu, fermentum et, dapibus sed, urna.\n\n'
                                        'Morbi mollis tellus ac sapien. Phasellus at dui in ligula mollis ultricies. Integer placerat tristique nisl. Praesent augue. Fusce commodo aliquam arcu. Nam commodo suscipit quam. Sed a libero. Pellentesque egestas, neque sit amet convallis pulvinar, justo nulla eleifend augue, ac auctor orci leo non est. Ut leo. Ut a nisl id ante tempus hendrerit. Curabitur nisi. Quisque malesuada placerat nisl. Nam ipsum risus, rutrum vitae, vestibulum eu, molestie vel, lacus. Sed lectus. Praesent elementum hendrerit tortor. Sed semper lorem at felis. Vestibulum volutpat, lacus a ultrices sagittis, mi neque euismod dui, eu pulvinar nunc sapien ornare nisl. Phasellus pede arcu, dapibus eu, fermentum et, dapibus sed, urna.',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                            showGentleSnackBar(
                              context,
                              'You must accept the terms and conditions',
                              type: SnackBarType.error,
                            );
                            return;
                          }
                          try {
                            await signUpUser(
                              ref,
                              context,
                              email,
                              password,
                              firstName,
                              familyName,
                            );

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
                            showGentleSnackBar(
                              context,
                              'Error: $e',
                              type: SnackBarType.error,
                            );
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        context.go('/verify_email');
                      },
                      child: const Text('Verify Email'),
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
        ],
      ),
    );
  }
}
