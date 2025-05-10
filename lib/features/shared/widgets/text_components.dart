import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  final IconData? preIcon;
  final IconData? postIcon;
  final TextStyle style;

  const CustomText({
    super.key,
    required this.text,
    this.preIcon,
    this.postIcon,
    this.style = const TextStyle(
        fontSize: UIConstants.normalTextSize, color: UIConstants.whiteColor),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (preIcon != null)
          Icon(preIcon, size: style.fontSize, color: style.color),
        if (preIcon != null) const SizedBox(width: 8),
        Text(
          text,
          style: style,
        ),
        if (postIcon != null) const SizedBox(width: 8),
        if (postIcon != null)
          Icon(postIcon, size: style.fontSize, color: style.color),
      ],
    );
  }
}
