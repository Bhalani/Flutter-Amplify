import 'package:flutter/material.dart';

class AppButtonStyles {
  static ButtonStyle filled(Color color) => TextButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  static ButtonStyle bordered(Color color) => OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        foregroundColor: color,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  static ButtonStyle text(Color color) => TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size.fromHeight(50),
      );
}
