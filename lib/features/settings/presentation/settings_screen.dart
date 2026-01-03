import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/ui_constants.dart';
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
      try {
        final availableBiometrics =
            await biometricService.localAuth.getAvailableBiometrics();
        debugPrint('Available biometrics: $availableBiometrics');
        final canCheck = await biometricService.canCheckBiometrics();
        if (!canCheck) {
          _showAlertDialog(
            'Biometrics Not Available',
            'Your device does not support biometric authentication.',
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
          _showAlertDialog(
            'Authentication Failed',
            'Biometric authentication was not successful.',
          );
        }
      } catch (e) {
        debugPrint('Error: $e');
        _showAlertDialog('Error', 'Biometric error: $e');
      }
    } else {
      await const FlutterSecureStorage()
          .write(key: 'biometrics_enabled', value: 'false');
      setState(() => biometricsEnabled = false);
      showGentleSnackBar(context, 'Biometrics disabled.',
          type: SnackBarType.info);
    }
    await _loadBiometricsState();
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: UIConstants.borderRadiusLg,
        ),
        title: Text(title, style: UIConstants.titleStyle),
        content: Text(message, style: UIConstants.bodyStyle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/account'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Security', style: UIConstants.captionStyle),
            const SizedBox(height: UIConstants.spaceSm),

            // Security Section Card
            Container(
              decoration: UIConstants.cardDecoration,
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.fingerprint_rounded,
                    iconColor: UIConstants.primaryColor,
                    title: 'Enable Biometrics',
                    subtitle: 'Use fingerprint or face to unlock',
                    trailing: Switch.adaptive(
                      value: biometricsEnabled,
                      onChanged: (_) => _toggleBiometrics(),
                      activeColor: UIConstants.primaryColor,
                    ),
                    onTap: _toggleBiometrics,
                    showDivider: true,
                  ),
                  _buildSettingsTile(
                    icon: Icons.lock_outline_rounded,
                    iconColor: UIConstants.primaryColor,
                    title: 'Update Password',
                    subtitle: 'Change your account password',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: UIConstants.mutedColor,
                    ),
                    onTap: () => context.go('/update_password'),
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: UIConstants.spaceLg),
            Text('Danger Zone', style: UIConstants.captionStyle),
            const SizedBox(height: UIConstants.spaceSm),

            // Danger Zone Card
            Container(
              decoration: BoxDecoration(
                color: UIConstants.surfaceColor,
                borderRadius: UIConstants.borderRadiusLg,
                border: Border.all(
                  color: UIConstants.dangerColor.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: UIConstants.shadowSm,
              ),
              child: _buildSettingsTile(
                icon: Icons.delete_forever_rounded,
                iconColor: UIConstants.dangerColor,
                title: 'Delete Account',
                subtitle: 'Permanently remove your account and data',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: UIConstants.mutedColor,
                ),
                onTap: () {
                  // TODO: Implement delete account logic
                },
                showDivider: false,
                isDanger: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
    required bool showDivider,
    bool isDanger = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: showDivider ? null : UIConstants.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.spaceMd),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(UIConstants.spaceSm),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: UIConstants.borderRadiusSm,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: UIConstants.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: UIConstants.mediumTextSize,
                          fontWeight: FontWeight.w600,
                          color: isDanger
                              ? UIConstants.dangerColor
                              : UIConstants.blackColor,
                        ),
                      ),
                      const SizedBox(height: UIConstants.spaceXs),
                      Text(
                        subtitle,
                        style: UIConstants.captionStyle,
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: UIConstants.spaceLg + 36,
            color: UIConstants.dividerColor,
          ),
      ],
    );
  }
}
