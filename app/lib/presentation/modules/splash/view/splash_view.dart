import 'package:flutter/material.dart';

import '../../../global/theme/colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.blue,
        ),
      ),
    );
  }
}
