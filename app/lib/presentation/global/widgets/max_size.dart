import 'package:flutter/material.dart';

class MaxSize extends StatelessWidget {
  const MaxSize({
    super.key,
    required this.width,
    this.height = double.infinity,
    required this.child,
  });
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        child: child,
      ),
    );
  }
}
