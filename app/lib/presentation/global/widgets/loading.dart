import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../generated/assets.gen.dart';

enum LoadingAnimationColor { dark, light }

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    super.key,
    this.size = 120,
    this.color = LoadingAnimationColor.dark,
  });

  final double size;
  final LoadingAnimationColor color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: RiveAnimation.asset(
        color == LoadingAnimationColor.dark ? Assets.misc.loadingDark : Assets.misc.loadingWhite,
      ),
    );
  }
}
