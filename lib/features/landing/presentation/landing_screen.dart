import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/logo_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text('Home'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/sign_up');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    context.go('/about_us');
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
  }
}
