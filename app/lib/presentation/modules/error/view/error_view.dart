import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../router/router.dart';

class ErrorView extends HookWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (context.mounted) {
              context.go(DashboardRoute.path);
            }
          },
        );
        return null;
      },
      [],
    );
    return const Scaffold();
  }
}
