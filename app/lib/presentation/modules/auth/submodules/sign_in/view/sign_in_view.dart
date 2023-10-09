import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:flutter_meedu/providers.dart';
import 'package:flutter_meedu/screen_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/translations.g.dart';
import '../../../../../global/extensions/sized_box.dart';
import '../../../../../global/extensions/widgets.dart';
import '../../../../../global/theme/colors.dart';
import '../../../../../global/utils/email_validator.dart';
import '../../../../../global/widgets/auto_scroll_view.dart';
import '../../../../../global/widgets/fetching_button.dart';
import '../../../../../global/widgets/secondary_button.dart';
import '../../../../../router/router.dart';
import '../bloc/sign_in_bloc.dart';
import 'dialogs/forgot_password.dart';
import 'utils/send_sign_in_form.dart';
import 'utils/sign_in_with_google.dart';
import 'widgets/password_field.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final bloc = ref.watch(
      signInProvider.select(
        (bloc) => bloc.fetching,
      ),
    );
    final state = bloc.state;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: AbsorbPointer(
          absorbing: state.fetching,
          child: AutoScrollView(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texts.signIn.title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).center,
              const SizedBox(height: 30),
              Text(texts.signUp.email),
              const SizedBox(height: 5),
              TextFormField(
                maxLines: 1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: bloc.onEmailChanged,
                textInputAction: TextInputAction.next,
                validator: (text) {
                  text = text?.trim() ?? '';
                  if (isValidEmail(text)) {
                    return null;
                  }
                  return texts.signUp.invalidFields.email;
                },
              ),
              const SizedBox(height: 20),
              Text(texts.signUp.password),
              const SizedBox(height: 5),
              Builder(builder: (context) {
                return PasswordTextField(
                  onChanged: bloc.onPasswordChanged,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) {
                    if (Form.of(context).validate()) {
                      sendSignInForm(context);
                    }
                  },
                );
              }),
              const SizedBox(height: 30),
              Row(
                children: [
                  TextButton(
                    onPressed: () => showForgotPasswordForm(context),
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                      child: Text(
                        texts.signIn.forgotPassword,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Builder(
                    builder: (context) => FetchingButton(
                      fetching: state.fetching,
                      onPressed: () {
                        if (Form.of(context).validate()) {
                          sendSignInForm(context);
                        }
                      },
                      text: texts.signIn.signIn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              if (kIsWeb) ...[
                SecondaryButton(
                  onPressed: () => signInWithGoogle(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.signIn.google,
                        height: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        texts.signIn.signInWithGoogle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () => DefaultTabController.of(context).index = 1,
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Text(texts.signIn.signUp),
              ).fullWidth,
              20.h,
              Text.rich(
                TextSpan(
                  text: texts.signIn.terms[0],
                  style: context.textTheme.bodySmall,
                  children: [
                    TextSpan(
                      text: texts.signIn.terms[1],
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          TermsAndPrivacyRoute().push(context);
                        },
                    ),
                    TextSpan(text: texts.signIn.terms[2]),
                    TextSpan(
                      text: texts.signIn.terms[3],
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          TermsAndPrivacyRoute().push(context);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
