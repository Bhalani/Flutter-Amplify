import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/widgets/logo_widget.dart';

class LandingScreen extends ConsumerWidget {
  final bool biometricFailed;
  final VoidCallback? onBiometricRetry;
  const LandingScreen(
      {super.key, this.biometricFailed = false, this.onBiometricRetry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final prefs = snapshot.data;
        final userEmail = prefs?.getString('user_email');
        return Scaffold(
          body: Column(
            children: [
              const LogoWidget(size: 200),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width < 600
                        ? MediaQuery.of(context).size.width * 0.9
                        : 500,
                    height: null, // Set height to auto
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (biometricFailed)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Biometric authentication failed',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.fingerprint, size: 24),
                            label: const Text('Retry with biometrics'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: onBiometricRetry,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const SizedBox(
                          height: 50,
                          child: Center(child: CircularProgressIndicator())),
                    if (snapshot.connectionState == ConnectionState.done &&
                        userEmail != null &&
                        userEmail.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          context.go('/sign_in');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text('Login'),
                      )
                    else if (snapshot.connectionState == ConnectionState.done)
                      ElevatedButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.go('/sign_up');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text('Register'),
                      ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.go('/about_us');
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      child: const Text('About us'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
