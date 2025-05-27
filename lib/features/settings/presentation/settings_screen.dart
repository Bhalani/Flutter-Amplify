import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool biometricsEnabled = false;

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
            onTap: () {
              setState(() {
                biometricsEnabled = !biometricsEnabled;
              });
            },
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
