import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign; // Add textAlign property

  const CustomText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign, // Initialize textAlign
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign, // Pass textAlign to Text widget
    );
  }
}
