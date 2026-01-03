import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../shared/widgets/logo_widget.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.spaceMd),
        child: Column(
          children: [
            const SizedBox(height: UIConstants.spaceLg),
            // Logo & App Name
            const Center(
              child: LogoWidget(size: 120),
            ),
            const SizedBox(height: UIConstants.spaceMd),
            Text(
              'Money Manager',
              style: UIConstants.headingStyle.copyWith(
                color: UIConstants.primaryColor,
              ),
            ),
            const SizedBox(height: UIConstants.spaceXs),
            Text(
              'v1.0.0',
              style: UIConstants.captionStyle,
            ),
            const SizedBox(height: UIConstants.spaceXl),

            // Description Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(UIConstants.spaceMd),
              decoration: UIConstants.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Mission',
                    style: UIConstants.subheadingStyle,
                  ),
                  const SizedBox(height: UIConstants.spaceSm),
                  Text(
                    'To provide a simple, secure, and smart way to manage your personal finances. We believe in financial freedom through clarity and control.',
                    style: UIConstants.bodyStyle,
                  ),
                  const SizedBox(height: UIConstants.spaceLg),
                  Text(
                    'Features',
                    style: UIConstants.subheadingStyle,
                  ),
                  const SizedBox(height: UIConstants.spaceSm),
                  _buildFeatureItem(
                      Icons.security_rounded, 'Bank-grade Security'),
                  _buildFeatureItem(Icons.sync_rounded, 'Real-time Sync'),
                  _buildFeatureItem(Icons.pie_chart_rounded, 'Smart Analytics'),
                ],
              ),
            ),

            const SizedBox(height: UIConstants.spaceLg),

            // Legal/Contact Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(UIConstants.spaceMd),
              decoration: UIConstants.cardDecoration,
              child: Column(
                children: [
                  _buildInfoRow(Icons.language_rounded, 'Website',
                      'www.moneymanager.com'),
                  Divider(color: UIConstants.dividerColor),
                  _buildInfoRow(
                      Icons.email_outlined, 'Support', 'help@moneymanager.com'),
                  Divider(color: UIConstants.dividerColor),
                  _buildInfoRow(Icons.privacy_tip_outlined, 'Privacy Policy',
                      'Read Policy'),
                ],
              ),
            ),

            const SizedBox(height: UIConstants.spaceXl),
            Text(
              '© 2024 Money Manager. All rights reserved.',
              style: UIConstants.captionStyle,
            ),
            const SizedBox(height: UIConstants.spaceLg),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.spaceXs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: UIConstants.successColor),
          const SizedBox(width: UIConstants.spaceSm),
          Text(text, style: UIConstants.bodyStyle),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.spaceSm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: UIConstants.slateGreyColor),
          const SizedBox(width: UIConstants.spaceMd),
          Expanded(
            child: Text(label, style: UIConstants.bodyStyle),
          ),
          Text(
            value,
            style: TextStyle(
              color: UIConstants.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: UIConstants.normalTextSize,
            ),
          ),
        ],
      ),
    );
  }
}
