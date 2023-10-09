import 'package:flutter/material.dart';
import 'package:flutter_meedu/screen_utils.dart';

import 'app_bar.dart';
import 'footer.dart';

class MainAppScaffold extends StatelessWidget {
  const MainAppScaffold({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Container(
        color: context.theme.scaffoldBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: child,
      ),
      bottomNavigationBar: const MainFooter(),
    );
  }
}
