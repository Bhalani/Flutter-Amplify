import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth/main.dart';

// Provider to fetch user email - always from current authenticated session
final userEmailProvider = FutureProvider.autoDispose<String?>((ref) async {
  try {
    // Always fetch fresh from Amplify Auth session (not stored locally)
    final userAttributes = await Amplify.Auth.fetchUserAttributes();
    final emailAttribute = userAttributes.firstWhere(
        (attr) => attr.userAttributeKey == AuthUserAttributeKey.email);
    debugPrint('Fetched email from active session: ${emailAttribute.value}');
    return emailAttribute.value;
  } catch (e) {
    debugPrint('Error fetching user email from session: $e');
    return null;
  }
});

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmailAsync = ref.watch(userEmailProvider);

    return Column(
      children: [
        const SizedBox(height: 45),
        const Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.person, size: 64, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),

        // User Email Display
        userEmailAsync.when(
          data: (email) => email != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    email,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox(),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Loading...',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          error: (error, stack) => const SizedBox(),
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
              if (context.mounted) {
                context.go('/sign_in');
              }
            } catch (e) {
              if (context.mounted) {
                showGentleSnackBar(
                  context,
                  'Sign out failed: $e',
                  type: SnackBarType.error,
                );
              }
            }
          },
        ),
      ],
    );
  }
}
