import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth/main.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        const Center(
          child: CircleAvatar(
            radius: 48,
            child: Icon(Icons.person, size: 64, color: Colors.white),
            backgroundColor: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 32),
        ListTile(
          leading: const Icon(Icons.subscriptions),
          title: const Text('Subscriptions'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            context.go('/settings');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () async {
            try {
              await Amplify.Auth.signOut();
              context.go('/sign_in');
            } catch (e) {
              showGentleSnackBar(
                context,
                'Sign out failed: $e',
                type: SnackBarType.error,
              );
            }
          },
        ),
      ],
    );
  }
}
