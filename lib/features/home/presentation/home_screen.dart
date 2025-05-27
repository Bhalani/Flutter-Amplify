import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth/main.dart';
import '../../shared/widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _navRoutes = [
    '/home',
    '/immobilienmiete',
    '/money_manager',
    '/insurance',
    '/account',
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      onNavTap: (index) {
        if (index != 0) {
          context.go(_navRoutes[index]);
        }
      },
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to home page!',
              style: TextStyle(fontFamily: 'Lato', fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
