import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
import 'router/app_router.dart';
import 'core/constants/ui_constants.dart';
import 'features/landing/presentation/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const ProviderScope(child: AmplifyAuthApp()));
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);

    debugPrint('Amplify configured successfully.');
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify is already configured.');
  } catch (e) {
    debugPrint('Error configuring Amplify: $e');
  }
}

class BiometricGate extends StatefulWidget {
  final Widget child;
  const BiometricGate({required this.child, super.key});

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate>
    with WidgetsBindingObserver {
  bool _unlocked = false;
  bool _checking = true;
  bool _biometricFailed = false;
  bool _isRetryingBiometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _secureStartupCheck();
  }

  Future<void> _secureStartupCheck() async {
    final storage = const FlutterSecureStorage();
    final biometricsEnabled =
        await storage.read(key: 'biometrics_enabled') == 'true';
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        if (biometricsEnabled) {
          // Always prompt for biometrics if enabled
          await _checkAuthAndBiometrics();
        } else {
          // If biometrics not enabled, log out and clear flag
          // await Amplify.Auth.signOut(); Enable it laster for final version
          await storage.delete(key: 'biometric_failed');
          setState(() {
            _unlocked = false;
            _checking = false;
            _biometricFailed = false;
          });
        }
      } else {
        debugPrint("biometricsEnabled: \\$biometricsEnabled");
        // Not signed in, allow access to child (login/register)
        setState(() {
          _unlocked = true;
          _checking = false;
          _biometricFailed = false;
        });
      }
    } catch (e) {
      // On error, allow access to child (login/register)
      setState(() {
        _unlocked = true;
        _checking = false;
        _biometricFailed = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // No-op: no longer handling logout on background/close
  }

  Future<void> _checkAuthAndBiometrics() async {
    final storage = const FlutterSecureStorage();
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        final localAuth = LocalAuthentication();
        try {
          final didAuthenticate = await localAuth.authenticate(
            localizedReason: 'Please authenticate to access the app',
          );
          if (didAuthenticate) {
            await storage.delete(key: 'biometric_failed');
          } else {
            await storage.write(key: 'biometric_failed', value: 'true');
          }
          setState(() {
            _unlocked = didAuthenticate;
            _checking = false;
            _biometricFailed = !didAuthenticate;
          });
        } catch (e) {
          await storage.write(key: 'biometric_failed', value: 'true');
          setState(() {
            _unlocked = false;
            _checking = false;
            _biometricFailed = true;
          });
        }
      } else {
        // Not signed in, allow access to child (login/register)
        await storage.delete(key: 'biometric_failed');
        setState(() {
          _unlocked = true;
          _checking = false;
          _biometricFailed = false;
        });
      }
    } catch (e) {
      await storage.delete(key: 'biometric_failed');
      setState(() {
        _unlocked = true;
        _checking = false;
        _biometricFailed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Stack(
        children: [
          LandingScreen(biometricFailed: false, onBiometricRetry: null),
          const Scaffold(
            backgroundColor: Colors.black54,
            body: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }
    if (!_unlocked) {
      return LandingScreen(
        biometricFailed: _biometricFailed,
        onBiometricRetry: () async {
          setState(() {
            _checking = true;
            _isRetryingBiometric = true;
          });
          await _checkAuthAndBiometrics();
          setState(() {
            _isRetryingBiometric = false;
          });
        },
      );
    }
    return widget.child;
  }
}

class AmplifyAuthApp extends StatelessWidget {
  const AmplifyAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lato',
        primaryColor: UIConstants.primaryColor,
        scaffoldBackgroundColor: UIConstants.backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: UIConstants.primaryColor,
          primary: UIConstants.primaryColor,
          secondary: UIConstants.accentSecondary,
          surface: UIConstants.surfaceColor,
          error: UIConstants.dangerColor,
          brightness: Brightness.light,
        ),
        // M3 Card Theme
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: UIConstants.borderRadiusMd,
          ),
          color: UIConstants.surfaceColor,
          surfaceTintColor: Colors.transparent,
        ),
        // Consistent 20dp radius - Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: UIConstants.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: const Size(48, 40),
            shape: RoundedRectangleBorder(
              borderRadius: UIConstants.borderRadiusLg, // 20dp consistent
            ),
          ),
        ),
        // Consistent 20dp radius - Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: UIConstants.primaryColor,
            foregroundColor: UIConstants.whiteColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: UIConstants.borderRadiusLg, // 20dp consistent
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        // Consistent 20dp radius - Outlined Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: UIConstants.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: const Size(48, 48),
            side: BorderSide(color: UIConstants.primaryColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: UIConstants.borderRadiusLg, // 20dp consistent
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        // Consistent 20dp radius - Filled Button
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: UIConstants.primaryColor,
            foregroundColor: UIConstants.whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: UIConstants.borderRadiusLg, // 20dp consistent
            ),
          ),
        ),
        // Consistent 20dp radius - Input Fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: UIConstants.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: UIConstants.borderRadiusLg, // 20dp consistent
            borderSide: BorderSide(color: UIConstants.borderLightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: UIConstants.borderRadiusLg,
            borderSide: BorderSide(color: UIConstants.borderLightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: UIConstants.borderRadiusLg,
            borderSide: BorderSide(color: UIConstants.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: UIConstants.borderRadiusLg,
            borderSide: BorderSide(color: UIConstants.dangerColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: UIConstants.borderRadiusLg,
            borderSide: BorderSide(color: UIConstants.dangerColor, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        // M3 AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: UIConstants.backgroundColor,
          foregroundColor: UIConstants.blackColor,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: false, // M3 default
          titleTextStyle: TextStyle(
            color: UIConstants.blackColor,
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Lato',
          ),
        ),
        // M3 Divider
        dividerTheme: DividerThemeData(
          color: UIConstants.dividerColor,
          thickness: 1,
          space: 0,
        ),
        // M3 Bottom Navigation
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: UIConstants.surfaceColor,
          selectedItemColor: UIConstants.primaryColor,
          unselectedItemColor: UIConstants.mutedColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        // M3 List Tile
        listTileTheme: ListTileThemeData(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          minVerticalPadding: 12,
          shape: RoundedRectangleBorder(
            borderRadius: UIConstants.borderRadiusSm,
          ),
        ),
        // M3 Snackbar
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: UIConstants.borderRadiusSm,
          ),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}

void showGentleSnackBar(BuildContext context, String message,
    {SnackBarType type = SnackBarType.info}) {
  Color backgroundColor;
  Color textColor;
  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      textColor = Colors.white;
      break;
    case SnackBarType.error:
      backgroundColor = const Color(0xFFFF3333); // Material Design dark red
      textColor = Colors.white;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.amber;
      textColor = Colors.black;
      break;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

InputDecoration getPlatformInputDecoration(String label) {
  if (Platform.isIOS) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: UIConstants.blackColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: UIConstants.blackColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: UIConstants.blackColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 12), // Reduced height
    );
  } else {
    return InputDecoration(
      labelText: label,
      border: const UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: UIConstants.blackColor, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: UIConstants.blackColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8), // Reduced height
    );
  }
}

enum SnackBarType { success, error, info }
