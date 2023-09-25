import 'package:flutter/material.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../router/router.dart';
import '../../bloc/sign_up_bloc.dart';

Future<void> sendSignUpForm(BuildContext context) async {
  final result = await signUpProvider.read.submit();

  if (context.mounted) {
    result.when(
      left: (failure) {
        final message = failure.when(
          duplicatedEmail: () => texts.signUp.failures.duplicated,
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
