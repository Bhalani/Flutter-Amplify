import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../main.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricsState();
  }

  Future<void> _loadBiometricsState() async {
    final storage = const FlutterSecureStorage();
    final enabled = await storage.read(key: 'biometrics_enabled');
    setState(() {
      biometricsEnabled = enabled == 'true';
    });
  }

  Future<void> _toggleBiometrics() async {
    final biometricService = ref.read(biometricServiceProvider);
    if (!biometricsEnabled) {
      // Enable biometrics
      try {
        final availableBiometrics =
            await biometricService.localAuth.getAvailableBiometrics();
        debugPrint('Available biometrics: $availableBiometrics');
        final canCheck = await biometricService.canCheckBiometrics();
        if (!canCheck) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Biometrics not available'),
              content: Text(
                  'Your device does not support biometric authentication.'),
            ),
          );
          return;
        }
        final authenticated = await biometricService.localAuth.authenticate(
          localizedReason: 'Please authenticate to enable biometrics',
        );
        if (authenticated) {
          await const FlutterSecureStorage()
              .write(key: 'biometrics_enabled', value: 'true');
          setState(() => biometricsEnabled = true);
          showGentleSnackBar(context, 'Biometrics enabled!',
              type: SnackBarType.success);
        } else {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Biometric Authentication Failed'),
              content: Text('Biometric authentication was not successful.'),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Biometric error: $e'),
          ),
        );
      }
    } else {
      await const FlutterSecureStorage()
          .write(key: 'biometrics_enabled', value: 'false');
      setState(() => biometricsEnabled = false);
      showGentleSnackBar(context, 'Biometrics disabled.',
          type: SnackBarType.info);
    }
    // Always reload state after toggle to ensure UI is correct
    await _loadBiometricsState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text('Back to Account'),
            onTap: () {
              context.go('/account');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Enable biometrics'),
            trailing: Icon(
              biometricsEnabled ? Icons.toggle_on : Icons.toggle_off,
              color: biometricsEnabled ? Colors.green : Colors.grey,
              size: 36,
            ),
            onTap: _toggleBiometrics,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Update password'),
            onTap: () {
              context.go('/update_password');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete Account',
                style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Implement delete account logic
            },
          ),
        ],
      ),
    );
  }
}
