// import 'package:flutter/material.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'features/home/presentation/home_screen.dart'; // Ensure HomePage is imported from main.dart

// class CustomAuthView extends StatefulWidget {
//   const CustomAuthView({super.key});

//   @override
//   CustomAuthViewState createState() => CustomAuthViewState();
// }

// class CustomAuthViewState extends State<CustomAuthView> {
//   // Removed local color definitions (_primaryColor and _secondaryColor)

//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   late final TextEditingController _confirmPasswordController;
//   late final TextEditingController _familyNameController;
//   late final TextEditingController _nameController;
//   late final TextEditingController _confirmationCodeController;
//   final _formKey = GlobalKey<FormState>();
//   String _message = '';
//   bool _isSignUp = false;
//   bool _isConfirming = false;
//   bool _isVerifyingExistingAccount = false;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _confirmPasswordController = TextEditingController();
//     _familyNameController = TextEditingController();
//     _nameController = TextEditingController();
//     _confirmationCodeController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _familyNameController.dispose();
//     _nameController.dispose();
//     _confirmationCodeController.dispose();
//     super.dispose();
//   }

//   Future<void> _signIn() async {
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       final result = await Amplify.Auth.signIn(
//         username: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       setState(() {
//         _message =
//             result.isSignedIn ? 'Sign in successful!' : 'Sign in failed.';
//         if (result.isSignedIn) {
//           // Navigate to HomePage on successful sign-in
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _message = 'Error signing in: $e';
//       });
//     }
//   }

//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_passwordController.text.trim() !=
//         _confirmPasswordController.text.trim()) {
//       setState(() {
//         _message = 'Passwords do not match.';
//       });
//       return;
//     }

//     try {
//       final result = await Amplify.Auth.signUp(
//         username: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//         options: SignUpOptions(userAttributes: {
//           AuthUserAttributeKey.email: _emailController.text.trim(),
//           AuthUserAttributeKey.familyName: _familyNameController.text.trim(),
//           AuthUserAttributeKey.name: _nameController.text.trim(),
//         }),
//       );
//       setState(() {
//         _message = result.isSignUpComplete
//             ? 'Sign up successful! Please sign in.'
//             : 'Check your email for confirmation code.';
//         _isConfirming = !result.isSignUpComplete;
//       });
//     } catch (e) {
//       setState(() {
//         _message = 'Error signing up: $e';
//       });
//     }
//   }

//   Future<void> _confirmSignUp() async {
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       final result = await Amplify.Auth.confirmSignUp(
//         username: _emailController.text.trim(),
//         confirmationCode: _confirmationCodeController.text.trim(),
//       );
//       setState(() {
//         if (result.isSignUpComplete) {
//           _message = 'Confirmation successful! Please sign in.';
//           _isConfirming = false;
//           _isSignUp = false; // Switch back to sign-in mode after confirmation
//         } else {
//           _message = 'Confirmation incomplete. Try again.';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _message = 'Invalid confirmation code. Please try again.';
//       });
//     }
//   }

//   Future<void> _resendVerificationCode() async {
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       await Amplify.Auth.resendSignUpCode(
//           username: _emailController.text.trim());
//       setState(() {
//         _message = 'Verification code sent to your email.';
//         _isConfirming = true; // Redirect to confirmation flow
//         _isVerifyingExistingAccount = false; // Exit the verify email form
//       });
//     } catch (e) {
//       setState(() {
//         _message = 'Error resending verification code: $e';
//       });
//     }
//   }

//   void _resetFields({bool preserveEmail = false}) {
//     if (!preserveEmail) {
//       _emailController.clear();
//     }
//     _passwordController.clear();
//     _confirmPasswordController.clear();
//     _familyNameController.clear();
//     _nameController.clear();
//     _confirmationCodeController.clear();
//     _message = '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _isSignUp
//               ? (_isConfirming ? 'Confirm Sign Up' : 'Sign Up')
//               : (_isVerifyingExistingAccount ? 'Verify Email' : 'Sign In'),
//           style: const TextStyle(
//             color: Colors.white, // White font color
//           ),
//         ),
//         backgroundColor: Theme.of(context).primaryColor, // Blue background
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const LogoWidget(),
//                   const SizedBox(height: 16),
//                   if (_isVerifyingExistingAccount) ...[
//                     EmailField(controller: _emailController),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: TextButton(
//                         onPressed: () {
//                           _resendVerificationCode();
//                           _resetFields(preserveEmail: true);
//                         },
//                         child: const Text('Send Verification Code'),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isVerifyingExistingAccount = false;
//                           _resetFields(preserveEmail: true);
//                         });
//                       },
//                       child: const Text(
//                         "Back to Sign In",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ] else if (_isConfirming) ...[
//                     ConfirmationCodeField(
//                         controller: _confirmationCodeController),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: TextButton(
//                         onPressed: () {
//                           _confirmSignUp();
//                           _resetFields(preserveEmail: true);
//                         },
//                         child: const Text('Confirm Sign Up'),
//                       ),
//                     ),
//                   ] else if (_isSignUp && !_isConfirming) ...[
//                     NameField(controller: _nameController),
//                     const SizedBox(height: 16),
//                     FamilyNameField(controller: _familyNameController),
//                     const SizedBox(height: 16),
//                     EmailField(controller: _emailController),
//                     const SizedBox(height: 16),
//                     PasswordField(controller: _passwordController),
//                     const SizedBox(height: 16),
//                     ConfirmPasswordField(
//                         controller: _confirmPasswordController),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: TextButton(
//                         onPressed: () {
//                           _signUp();
//                           _resetFields(preserveEmail: true);
//                         },
//                         child: const Text('Sign Up'),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isSignUp = false;
//                           _resetFields(preserveEmail: true);
//                         });
//                       },
//                       child: const Text(
//                         "Already have an account? Sign In",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ] else ...[
//                     EmailField(controller: _emailController),
//                     const SizedBox(height: 16),
//                     PasswordField(controller: _passwordController),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: TextButton(
//                         onPressed: () {
//                           _signIn();
//                           _resetFields(preserveEmail: true);
//                         },
//                         child: const Text('Sign In'),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isSignUp = true;
//                           _resetFields(preserveEmail: true);
//                         });
//                       },
//                       child: const Text(
//                         "Don't have an account? Sign Up",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isVerifyingExistingAccount = true;
//                           _resetFields(preserveEmail: true);
//                         });
//                       },
//                       child: const Text(
//                         "Verify unverified email",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 16),
//                   if (_message.isNotEmpty)
//                     Text(
//                       _message,
//                       style: TextStyle(
//                         color: _message.contains('successful')
//                             ? Colors.green
//                             : Colors.red,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LogoWidget extends StatelessWidget {
//   const LogoWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       'assets/images/logo.png',
//       width: 144,
//       height: 117,
//     );
//   }
// }

// class NameField extends StatelessWidget {
//   final TextEditingController controller;
//   const NameField({required this.controller, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: const InputDecoration(
//         labelText: 'Name',
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your name';
//         }
//         return null;
//       },
//     );
//   }
// }

// class FamilyNameField extends StatelessWidget {
//   final TextEditingController controller;
//   const FamilyNameField({required this.controller, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: const InputDecoration(
//         labelText: 'Family Name',
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your family name';
//         }
//         return null;
//       },
//     );
//   }
// }

// class EmailField extends StatelessWidget {
//   final TextEditingController controller;
//   const EmailField({required this.controller, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: getPlatformInputDecoration('Email'),
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) => value == null || !value.contains('@')
//           ? 'Enter a valid email'
//           : null,
//     );
//   }
// }

// class PasswordField extends StatelessWidget {
//   final TextEditingController controller;
//   const PasswordField({required this.controller, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: getPlatformInputDecoration('Password'),
//       obscureText: true,
//       validator: (value) => value == null || value.length < 8
//           ? 'Password must be at least 8 characters long'
//           : null,
//     );
//   }
// }

// class ConfirmPasswordField extends StatelessWidget {
//   final TextEditingController controller;
//   const ConfirmPasswordField({required this.controller, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: getPlatformInputDecoration('Confirm Password'),
//       obscureText: true,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please confirm your password';
//         }
//         if (value != _passwordController.text) {
//           return 'Passwords do not match';
//         }
//         return null;
//       },
//     );
//   }
// }

// class ConfirmationCodeField extends StatelessWidget {
//   final TextEditingController controller;
//   const ConfirmationCodeField({required this.controller, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: const InputDecoration(
//         labelText: 'Confirmation Code',
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter the confirmation code';
//         }
//         return null;
//       },
//     );
//   }
// }
