import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 3,
      onNavTap: (index) {
        if (index != 3) {
          // Use GoRouter for navigation
          context.go(_navRoutes[index]);
        }
      },
      appBar: AppBar(title: const Text('Insurance')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction,
                size: 64, color: Color(0xFFFFC107)), // dark yellow
            SizedBox(height: 16),
            Text('Insurance is under development',
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
