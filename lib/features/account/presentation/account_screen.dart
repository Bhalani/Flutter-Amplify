import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/constants/ui_constants.dart';

// Provider to fetch user email - always from current authenticated session
final userEmailProvider = FutureProvider.autoDispose<String?>((ref) async {
  try {
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

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header with Gradient
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + UIConstants.spaceLg,
              bottom: UIConstants.spaceLg,
              left: UIConstants.spaceMd,
              right: UIConstants.spaceMd,
            ),
            decoration: BoxDecoration(
              gradient: UIConstants.primaryGradient,
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: UIConstants.whiteColor,
                    ),
                  ),
                ),
                const SizedBox(height: UIConstants.spaceMd),

                // User Email
                userEmailAsync.when(
                  data: (email) => email != null
                      ? Text(
                          email,
                          style: TextStyle(
                            fontSize: UIConstants.mediumTextSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                  loading: () => Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),

          // Menu Items
          Padding(
            padding: const EdgeInsets.all(UIConstants.spaceMd),
            child: Container(
              decoration: UIConstants.cardDecoration,
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.subscriptions_rounded,
                    iconColor: UIConstants.accentSecondary,
                    title: 'Subscriptions',
                    subtitle: 'Manage your subscription plan',
                    onTap: () {},
                    showDivider: true,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_rounded,
                    iconColor: UIConstants.slateGreyColor,
                    title: 'Settings',
                    subtitle: 'Privacy, security, and preferences',
                    onTap: () => context.go('/settings'),
                    showDivider: true,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout_rounded,
                    iconColor: UIConstants.dangerColor,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
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
                    showDivider: false,
                    isDanger: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
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
                Icon(
                  Icons.chevron_right_rounded,
                  color: UIConstants.mutedColor,
                ),
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
