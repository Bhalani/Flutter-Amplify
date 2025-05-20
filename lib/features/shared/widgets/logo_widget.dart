import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size; // Accept size as an argument

  const LogoWidget({super.key, this.size = 150}); // Default size is 100

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size, // Use the size argument
      height: size, // Maintain aspect ratio
    );
  }
}
