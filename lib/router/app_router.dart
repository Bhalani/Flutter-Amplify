import 'package:go_router/go_router.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/auth/presentation/verify_email_screen.dart';
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
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/verify_email',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
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
  ],
);
