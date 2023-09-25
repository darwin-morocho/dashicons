import 'package:flutter/material.dart';

import '../theme/colors.dart';

class FetchingButton extends StatelessWidget {
  const FetchingButton({
    super.key,
    required this.fetching,
    required this.onPressed,
    required this.text,
    this.style,
  });
  final bool fetching;
  final VoidCallback onPressed;
  final String text;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: fetching
          ? const ClipOval(
              child: Material(
                color: AppColors.dark,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : ElevatedButton(
              style: style,
              onPressed: onPressed,
              child: Text(text),
            ),
    );
  }
}
