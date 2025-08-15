import 'package:flutter/material.dart';

class UIConstants {
  // Colors
  static const Color primaryColor = Color.fromARGB(255, 4, 71, 100);
  static const Color primaryLightColor =
      Color.fromARGB(255, 180, 210, 220); // Lighter and closer to primary
  static const Color secondaryColor = Color.fromARGB(255, 245, 245, 245);
  static const Color backgroundColor = Color.fromARGB(252, 252, 252, 252);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color slateGreyColor = Color(0xFF334155);
  // Light grey for box borders
  static const Color borderLightGrey = Color.fromARGB(255, 218, 217, 217);

  // Button Sizes
  static const Size largeButton = Size(double.infinity, 50);
  static const Size mediumButton = Size(200, 40);
  static const Size smallButton = Size(100, 30);

  // Text Sizes
  static const double headerTextSize = 32.0; // Header size
  static const double subHeaderTextSize = 24.0; // Sub-header size
  static const double mediumTextSize = 18.0; // Medium text size
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

  static String getCurrencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'CHF':
        return '₣';
      case 'SEK':
        return 'kr';
      case 'NOK':
        return 'kr';
      case 'DKK':
        return 'kr';
      case 'PLN':
        return 'zł';
      case 'CZK':
        return 'Kč';
      case 'HUF':
        return 'Ft';
      case 'RON':
        return 'lei';
      case 'HRK':
        return 'kn';
      case 'RSD':
        return 'дин';
      case 'BGN':
        return 'лв';
      case 'TRY':
        return '₺';
      default:
        return code;
    }
  }
}
