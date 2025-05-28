import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../features/immobilienmiete/presentation/immobilienmiete_screen.dart';
import '../features/money_manager/presentation/money_manager_screen.dart';
import '../features/insurance/presentation/insurance_screen.dart';
import '../features/account/presentation/account_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/settings/presentation/update_password_screen.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true, // Enable debug logs for routing
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final userEmail = prefs.getString('user_email');
        if (userEmail != null && userEmail.isNotEmpty) {
          return '/sign_in';
        }
        return null;
      },
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
        final extra = state.extra as Map<String, dynamic>?;
        final email = extra?['email'] as String? ?? '';
        final fromSignUp = extra?['fromSignUp'] as bool? ?? false;
        return VerificationCodeScreen(email: email, fromSignUp: fromSignUp);
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
    GoRoute(
      path: '/immobilienmiete',
      builder: (context, state) => const ImmobilienmieteScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return null;
          }
        } catch (e) {}
        return '/sign_in';
      },
    ),
    GoRoute(
      path: '/money_manager',
      builder: (context, state) => const MoneyManagerScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return null;
          }
        } catch (e) {}
        return '/sign_in';
      },
    ),
    GoRoute(
      path: '/insurance',
      builder: (context, state) => const InsuranceScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return null;
          }
        } catch (e) {}
        return '/sign_in';
      },
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return null;
          }
        } catch (e) {}
        return '/sign_in';
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return null;
          }
        } catch (e) {}
        return '/sign_in';
      },
    ),
    GoRoute(
      path: '/update_password',
      builder: (context, state) => const UpdatePasswordScreen(),
      redirect: (context, state) async {
        try {
          final session = await Amplify.Auth.fetchAuthSession();
          if (session.isSignedIn) {
            return null;
          }
        } catch (e) {}
        return '/sign_in';
      },
    ),
  ],
);
