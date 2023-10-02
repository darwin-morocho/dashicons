import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../theme/colors.dart';

class MainFooter extends StatelessWidget {
  const MainFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.darkLight),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© 2023 meedu.app | MIT License |',
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () => launchUrlString(
                'https://github.com/darwin-morocho/dashicons',
              ),
              child: Text(
                'GitHub',
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
