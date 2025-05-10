import 'package:flutter/material.dart';

class CustomAuthView extends StatelessWidget {
  const CustomAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Auth View'),
      ),
      body: const Center(
        child: Text('This is the Custom Auth View'),
      ),
    );
  }
}
