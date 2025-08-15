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
import 'core/widgets/deep_link_initializer.dart';
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
        primaryColor: UIConstants.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: UIConstants.primaryColor,
          secondary: UIConstants.secondaryColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.resolveWith<Size>((states) {
              if (MediaQuery.of(context).size.width < 600) {
                // Mobile view: 80% width
                return Size(MediaQuery.of(context).size.width * 0.85, 40);
              } else {
                // Tablet view: Fixed size
                return const Size(200, 40);
              }
            }),
            maximumSize: WidgetStateProperty.resolveWith<Size>((states) {
              if (MediaQuery.of(context).size.width < 600) {
                // Mobile view: 90% width
                return Size(MediaQuery.of(context).size.width * 0.9, 50);
              } else {
                // Tablet view: Fixed size
                return const Size(350, 50);
              }
            }),
            foregroundColor:
                WidgetStateProperty.all(UIConstants.slateGreyColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.resolveWith<Size>((states) {
              if (MediaQuery.of(context).size.width < 600) {
                // Mobile view: 80% width
                return Size(MediaQuery.of(context).size.width * 0.85, 40);
              } else {
                // Tablet view: Fixed size
                return const Size(200, 40);
              }
            }),
            maximumSize: WidgetStateProperty.resolveWith<Size>((states) {
              if (MediaQuery.of(context).size.width < 600) {
                return Size(MediaQuery.of(context).size.width * 0.9, 50);
              } else {
                return const Size(350, 50);
              }
            }),
            backgroundColor: WidgetStateProperty.all(UIConstants.primaryColor),
            foregroundColor: WidgetStateProperty.all(UIConstants.whiteColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.resolveWith<Size>((states) {
              if (MediaQuery.of(context).size.width < 600) {
                // Mobile view: 80% width
                return Size(MediaQuery.of(context).size.width * 0.85, 40);
              } else {
                // Tablet view: Fixed size
                return const Size(200, 40);
              }
            }),
            maximumSize: WidgetStateProperty.resolveWith<Size>((states) {
              if (MediaQuery.of(context).size.width < 600) {
                // Mobile view: 90% width
                return Size(MediaQuery.of(context).size.width * 0.9, 50);
              } else {
                // Tablet view: Fixed size
                return const Size(350, 50);
              }
            }),
            side: WidgetStateProperty.all(
              BorderSide(color: UIConstants.primaryColor, width: 1),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            foregroundColor: WidgetStateProperty.all(UIConstants.primaryColor),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      routerConfig: appRouter,
      builder: (context, child) => DeepLinkInitializer(
        child: BiometricGate(child: child!),
      ),
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
