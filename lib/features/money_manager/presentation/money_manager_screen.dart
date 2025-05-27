import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';

class MoneyManagerScreen extends StatelessWidget {
  const MoneyManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 2,
      onNavTap: (index) {
        if (index != 2) {
          // Use GoRouter for navigation
          context.go(_navRoutes[index]);
        }
      },
      appBar: AppBar(title: const Text('Money manager')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction,
                size: 64, color: Color(0xFFFFC107)), // dark yellow
            SizedBox(height: 16),
            Text('Money manager is under development',
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
