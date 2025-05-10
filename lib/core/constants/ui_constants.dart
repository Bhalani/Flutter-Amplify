import 'package:flutter/material.dart';

class UIConstants {
  // Colors
  static const Color primaryColor = Color(0xFF117098);
  static const Color secondaryColor = Color(0xFFc4bfaf);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color slateGreyColor = Color(0xFF334155);

  // Button Sizes
  static const Size largeButton = Size(double.infinity, 50);
  static const Size mediumButton = Size(200, 40);
  static const Size smallButton = Size(100, 30);

  // Text Sizes
  static const double headerTextSize = 32.0; // Header size
  static const double subHeaderTextSize = 24.0; // Sub-header size
  static const double normalTextSize = 16.0; // Normal text size
  static const double smallTextSize = 12.0; // Small text size

  // Form Style
  static final InputDecoration formInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  );
}
