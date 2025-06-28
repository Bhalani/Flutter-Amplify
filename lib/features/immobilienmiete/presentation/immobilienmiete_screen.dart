import 'package:flutter/material.dart';

class ImmobilienmieteScreen extends StatelessWidget {
  const ImmobilienmieteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.construction, size: 64, color: Color(0xFFFFC107)),
          SizedBox(height: 16),
          Text('Immobilienmiete is under development',
              style: TextStyle(fontSize: 18, color: Color(0xFFFFC107))),
        ],
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
