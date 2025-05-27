import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';

class ImmobilienmieteScreen extends StatelessWidget {
  const ImmobilienmieteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      onNavTap: (index) {
        if (index != 1) {
          // Use GoRouter for navigation
          context.go(_navRoutes[index]);
        }
      },
      appBar: AppBar(title: const Text('Immobilienmiete')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction,
                size: 64, color: Color(0xFFFFC107)), // dark yellow
            SizedBox(height: 16),
            Text('Immobilienmiete is under development',
                style: TextStyle(fontSize: 18, color: Color(0xFFFFC107))),
          ],
        ),
      ),
    );
  }

  static const _navRoutes = [
    '/home',
    '/immobilienmiete',
    '/money_manager',
    '/insurance',
    '/account',
  ];
}
