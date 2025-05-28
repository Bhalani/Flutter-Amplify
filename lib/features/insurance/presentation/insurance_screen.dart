import 'package:flutter/material.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.construction, size: 64, color: Color(0xFFFFC107)),
          SizedBox(height: 16),
          Text('Insurance is under development',
              style: TextStyle(fontSize: 18, color: Color(0xFFFFC107))),
        ],
      ),
    );
  }
}
