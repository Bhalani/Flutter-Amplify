import 'package:flutter/material.dart';
import '../../shared/widgets/logo_widget.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(), // Added logo to the app bar
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Verify Email Screen'),
            ElevatedButton(
              onPressed: () {
                // Navigate to Sign In
                Navigator.of(context).pushNamed('/sign_in');
              },
              child: const Text('Go to Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
