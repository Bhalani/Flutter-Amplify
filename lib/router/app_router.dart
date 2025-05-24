import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/auth/presentation/verify_email_screen.dart';
import '../features/auth/presentation/verification_code_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/design_components/presentation/ui_components_screen.dart';
import '../features/design_components/presentation/new_ui_components_screen.dart';
import '../features/landing/presentation/landing_screen.dart';
import "../features/about_us/presentation/about_us_screen.dart";

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true, // Enable debug logs for routing
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/sign_in',
      builder: (context, state) => const SignInScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return '/home';
          }
        } catch (e) {}
        return null;
      },
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => const SignUpScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return '/home';
          }
        } catch (e) {}
        return null;
      },
    ),
    GoRoute(
      path: '/code_verification',
      builder: (context, state) {
        final email = state.extra as String;
        return VerificationCodeScreen(email: email);
      },
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return '/home';
          }
        } catch (e) {}
        return null;
      },
    ),
    GoRoute(
      path: '/verify_email',
      builder: (context, state) => const VerifyEmailScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return '/home';
          }
        } catch (e) {}
        return null;
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return null; // allow access
          } else {
            return '/sign_in';
          }
        } catch (e) {
          return '/sign_in';
        }
      },
    ),
    GoRoute(
      path: '/design_components',
      builder: (context, state) => const UIComponentsScreen(),
    ),
    GoRoute(
      path: '/new_ui_components',
      builder: (context, state) => const NewUIComponentsScreen(),
    ),
    GoRoute(
      path: '/about_us',
      builder: (context, state) => const AboutUsScreen(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return '/home';
          }
        } catch (e) {}
        return null;
      },
    ),
  ],
);
