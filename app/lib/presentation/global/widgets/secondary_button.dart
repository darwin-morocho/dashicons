import 'package:flutter/material.dart';

import '../theme/colors.dart';

class SecondaryButton extends StatelessWidget {
  factory SecondaryButton.text(
    String text, {
    VoidCallback? onPressed,
    OutlinedBorder? shape,
    Color? foregroundColor,
    TextStyle? textStyle,
  }) {
    return SecondaryButton(
      foregroundColor: foregroundColor ?? AppColors.dark,
      shape: shape,
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
  const SecondaryButton({
    super.key,
    this.onPressed,
    this.shape,
    this.foregroundColor = AppColors.dark,
    required this.child,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final OutlinedBorder? shape;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed != null ? 1 : 0.3,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(
            Colors.white,
          ),
          surfaceTintColor: const MaterialStatePropertyAll(
            Colors.white,
          ),
          shape: MaterialStatePropertyAll(shape),
          overlayColor: MaterialStatePropertyAll(
            foregroundColor.withOpacity(0.1),
          ),
          elevation: const MaterialStatePropertyAll(0),
          foregroundColor: MaterialStatePropertyAll(foregroundColor),
        ),
        child: child,
      ),
    );
  }
}
