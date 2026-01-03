import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/ui_constants.dart';
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
      builder: (builderContext, snapshot) {
        final prefs = snapshot.data;
        final userEmail = prefs?.getString('user_email');
        return Scaffold(
          backgroundColor: UIConstants.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: UIConstants.spaceLg),
                const LogoWidget(size: 180),
                const SizedBox(height: UIConstants.spaceMd),

                // Main content area
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UIConstants.spaceLg,
                      ),
                      child: Image.asset(
                        'assets/images/background.png',
                        fit: BoxFit.contain,
                        width: MediaQuery.of(builderContext).size.width < 600
                            ? MediaQuery.of(builderContext).size.width * 0.85
                            : 450,
                      ),
                    ),
                  ),
                ),

                // Bottom action area
                Container(
                  padding: const EdgeInsets.all(UIConstants.spaceLg),
                  decoration: BoxDecoration(
                    color: UIConstants.surfaceColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(UIConstants.radiusXl),
                      topRight: Radius.circular(UIConstants.radiusXl),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (biometricFailed)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: UIConstants.spaceMd,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: UIConstants.spaceMd,
                                  vertical: UIConstants.spaceSm,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      UIConstants.dangerColor.withOpacity(0.1),
                                  borderRadius: UIConstants.borderRadiusSm,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: UIConstants.dangerColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: UIConstants.spaceSm),
                                    Text(
                                      'Biometric authentication failed',
                                      style: TextStyle(
                                        color: UIConstants.dangerColor,
                                        fontSize: UIConstants.smallTextSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: UIConstants.spaceMd),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.fingerprint, size: 22),
                                label: const Text('Retry Biometrics'),
                                onPressed: onBiometricRetry,
                              ),
                            ],
                          ),
                        ),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Padding(
                          padding: EdgeInsets.all(UIConstants.spaceMd),
                          child: CircularProgressIndicator(),
                        ),
                      if (snapshot.connectionState == ConnectionState.done &&
                          userEmail != null &&
                          userEmail.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            Future.delayed(Duration.zero, () {
                              GoRouter.of(context).go('/sign_in');
                            });
                          },
                          child: const Text('Login'),
                        )
                      else if (snapshot.connectionState == ConnectionState.done)
                        ElevatedButton(
                          onPressed: () {
                            Future.delayed(Duration.zero, () {
                              GoRouter.of(context).go('/sign_up');
                            });
                          },
                          child: const Text('Get Started'),
                        ),
                      const SizedBox(height: UIConstants.spaceMd),
                      OutlinedButton(
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            GoRouter.of(context).go('/about_us');
                          });
                        },
                        child: const Text('About Us'),
                      ),
                      const SizedBox(height: UIConstants.spaceSm),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
