// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'core/providers/auth_provider.dart';
// import 'features/auth/presentation/sign_in_screen.dart';
// import 'features/home/presentation/home_screen.dart';

// class AmplifyAuthApp extends ConsumerWidget {
//   const AmplifyAuthApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isSignedIn = ref.watch(authStateProvider);

//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: const Color(0xFF4E7395),
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           primary: const Color(0xFF4E7395),
//           secondary: const Color(0xFF325695),
//         ),
//       ),
//       home: isSignedIn ? const HomeScreen() : const SignInScreen(),
//     );
//   }
// }
