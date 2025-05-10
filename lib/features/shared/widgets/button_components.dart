import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData? preIcon;
  final IconData? postIcon;
  final ButtonStyle? style;
  final String size; // Added size parameter (large, medium, small)

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.preIcon,
    this.postIcon,
    this.style,
    this.size = 'medium', // Default to medium size
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry padding;
    final TextStyle textStyle;

    switch (size) {
      case 'large':
        padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0);
        textStyle = const TextStyle(
            fontSize: UIConstants.subHeaderTextSize,
            fontWeight: FontWeight.bold);
        break;
      case 'small':
        padding = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0);
        textStyle = const TextStyle(fontSize: UIConstants.smallTextSize);
        break;
      case 'medium':
      default:
        padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
        textStyle = const TextStyle(fontSize: UIConstants.normalTextSize);
        break;
    }

    return ElevatedButton(
      style: (style ??
          ElevatedButton.styleFrom(
            backgroundColor: UIConstants.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: padding,
            textStyle: textStyle,
          )),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (preIcon != null) Icon(preIcon, size: textStyle.fontSize),
          if (preIcon != null) const SizedBox(width: 8),
          Text(title),
          if (postIcon != null) const SizedBox(width: 8),
          if (postIcon != null) Icon(postIcon, size: textStyle.fontSize),
        ],
      ),
    );
  }
}
