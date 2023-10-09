import 'package:flutter/material.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../router/router.dart';
import '../../bloc/sign_in_bloc.dart';

Future<void> sendSignInForm(BuildContext context) async {
  final result = await signInProvider.read().submit();

  if (context.mounted) {
    result.when(
      left: (failure) {
        final message = failure.when(
          disabled: () => 'disabled',
          invalidPassword: () => 'invalid password',
          userNotFound: () => 'user not found',
          network: () => texts.misc.failures.network,
          tooManyRequests: () => texts.misc.failures.tooManyRequest,
          unhandledException: () => texts.misc.failures.unhandled,
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
