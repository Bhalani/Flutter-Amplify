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
import '../features/shared/widgets/app_scaffold.dart';

/// Instant transition with no animation to prevent ghosting effect
CustomTransitionPage<void> buildNoAnimationTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

/// Helper to check auth session
Future<bool> _isSignedIn() async {
  try {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  } catch (e) {
    return false;
  }
}

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true, // Enable debug logs for routing
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const LandingScreen(),
        state: state,
      ),
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
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const SignInScreen(),
        state: state,
      ),
      redirect: (context, state) async {
        if (await _isSignedIn()) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/sign_up',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const SignUpScreen(),
        state: state,
      ),
      redirect: (context, state) async {
        if (await _isSignedIn()) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/code_verification',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final email = extra?['email'] as String? ?? '';
        final fromSignUp = extra?['fromSignUp'] as bool? ?? false;
        return buildNoAnimationTransition(
          child: VerificationCodeScreen(email: email, fromSignUp: fromSignUp),
          state: state,
        );
      },
      redirect: (context, state) async {
        if (await _isSignedIn()) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/verify_email',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const VerifyEmailScreen(),
        state: state,
      ),
      redirect: (context, state) async {
        if (await _isSignedIn()) {
          return '/home';
        }
        return null;
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        // Determine current index from location
        final location = state.location;
        int currentIndex = 0;
        if (location.startsWith('/immobilienmiete')) {
          currentIndex = 1;
        } else if (location.startsWith('/money_manager'))
          currentIndex = 2;
        else if (location.startsWith('/insurance'))
          currentIndex = 3;
        else if (location.startsWith('/account')) currentIndex = 4;
        // AppScaffold keeps the bottom nav fixed
        return AppScaffold(
          currentIndex: currentIndex,
          onNavTap: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/immobilienmiete');
                break;
              case 2:
                context.go('/money_manager');
                break;
              case 3:
                context.go('/insurance');
                break;
              case 4:
                context.go('/account');
                break;
            }
          },
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => buildNoAnimationTransition(
            child: const HomeScreen(),
            state: state,
          ),
          redirect: (context, state) async {
            if (!await _isSignedIn()) {
              return '/sign_in';
            }
            return null;
          },
        ),
        GoRoute(
          path: '/immobilienmiete',
          pageBuilder: (context, state) => buildNoAnimationTransition(
            child: const ImmobilienmieteScreen(),
            state: state,
          ),
          redirect: (context, state) async {
            if (!await _isSignedIn()) {
              return '/sign_in';
            }
            return null;
          },
        ),
        GoRoute(
          path: '/money_manager',
          pageBuilder: (context, state) => buildNoAnimationTransition(
            child: const MoneyManagerScreen(),
            state: state,
          ),
          redirect: (context, state) async {
            if (!await _isSignedIn()) {
              return '/sign_in';
            }
            return null;
          },
        ),
        GoRoute(
          path: '/insurance',
          pageBuilder: (context, state) => buildNoAnimationTransition(
            child: const InsuranceScreen(),
            state: state,
          ),
          redirect: (context, state) async {
            if (!await _isSignedIn()) {
              return '/sign_in';
            }
            return null;
          },
        ),
        GoRoute(
          path: '/account',
          pageBuilder: (context, state) => buildNoAnimationTransition(
            child: const AccountScreen(),
            state: state,
          ),
          redirect: (context, state) async {
            if (!await _isSignedIn()) {
              return '/sign_in';
            }
            return null;
          },
        ),
      ],
    ),
    GoRoute(
      path: '/design_components',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const UIComponentsScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/new_ui_components',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const NewUIComponentsScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/about_us',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const AboutUsScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/forgot_password',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const ForgotPasswordScreen(),
        state: state,
      ),
      redirect: (context, state) async {
        if (await _isSignedIn()) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const SettingsScreen(),
        state: state,
      ),
      redirect: (context, state) async {
        if (!await _isSignedIn()) {
          return '/sign_in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/update_password',
      pageBuilder: (context, state) => buildNoAnimationTransition(
        child: const UpdatePasswordScreen(),
        state: state,
      ),
      redirect: (context, state) async {
        if (!await _isSignedIn()) {
          return '/sign_in';
        }
        return null;
      },
    ),
  ],
);
