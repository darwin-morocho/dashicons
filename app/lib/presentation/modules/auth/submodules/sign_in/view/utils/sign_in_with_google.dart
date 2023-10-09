import 'package:flutter/material.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/widgets/loader.dart';
import '../../../../../../router/router.dart';
import '../../bloc/sign_in_bloc.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  final result = await Loader.show(
    context,
    signInProvider.read().signInWithGoogle(),
  );
  if (context.mounted) {
    result.when(
      left: (failure) {
        final message = failure.when(
          network: () => texts.misc.failures.network,
          tooManyRequests: () => texts.misc.failures.tooManyRequest,
          unhandledException: () => texts.misc.failures.unhandled,
          duplicatedEmail: () => texts.signUp.failures.duplicated,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
      right: (_) => DashboardRoute().go(context),
    );
  }
}
