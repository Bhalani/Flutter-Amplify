import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
import 'router/app_router.dart';
import 'core/constants/ui_constants.dart';

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
                // Mobile view: 90% width
                return Size(MediaQuery.of(context).size.width * 0.9, 50);
              } else {
                // Tablet view: Fixed size
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
              BorderSide(color: UIConstants.primaryColor, width: 2),
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
      backgroundColor = Colors.red;
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

enum SnackBarType { success, error, info }
