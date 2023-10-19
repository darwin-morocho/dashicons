import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_meedu/rx.dart';
import 'package:flutter_meedu/screen_utils.dart';
import 'package:hooks_meedu/rx_hook.dart';

import '../../../../../../../domain/use_cases/auth/send_reset_password_email.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/dialogs/alert.dart';
import '../../../../../../global/extensions/sized_box.dart';
import '../../../../../../global/theme/colors.dart';
import '../../../../../../global/utils/email_validator.dart';
import '../../../../../../global/widgets/loader.dart';
import '../../../../../../global/widgets/secondary_button.dart';

Future<void> showForgotPasswordForm(BuildContext context) async {
  final email = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ForgotPasswordForm(),
  );
  // ignore: use_build_context_synchronously
  if (email == null || !context.mounted) {
    return;
  }

  // ignore: use_build_context_synchronously
  final result = await Loader.show(
    context,
    SendResetPasswordEmailUseCase(
      Repositories.auth.read(),
    )(email),
  );

  if (context.mounted) {
    final message = result.when(
      left: (failure) => failure.maybeWhen(
        network: () => texts.misc.failures.network,
        notFound: () => texts.signIn.forgotPasswordDialog.emailNotFound(email: email),
        orElse: () => texts.misc.failures.unhandled,
      ),
      right: (_) => texts.signIn.forgotPasswordDialog.success,
    );
    showAlertDialog(
      context: context,
      message: message,
    );
  }
}

class ForgotPasswordForm extends HookWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final email = useRx('');
    return AlertDialog(
      title: Text(texts.signIn.forgotPasswordDialog.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 360,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(texts.signIn.forgotPasswordDialog.label),
            20.h,
            TextField(
              onChanged: (text) => email.value = text.trim(),
              decoration: const InputDecoration(
                hintText: 'email@example.com',
              ),
            ),
            20.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton.text(
                  texts.misc.cancel,
                  textStyle: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.red,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                20.w,
                RxBuilder(
                  (_) => ElevatedButton(
                    onPressed: isValidEmail(email.value)
                        ? () {
                            Navigator.pop(context, email.value);
                          }
                        : null,
                    child: Text(
                      texts.signIn.forgotPasswordDialog.button.toUpperCase(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
