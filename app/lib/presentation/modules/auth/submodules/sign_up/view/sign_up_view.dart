import 'package:flutter/material.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:flutter_meedu/providers.dart';
import 'package:flutter_meedu/screen_utils.dart';

import '../../../../../generated/translations.g.dart';
import '../../../../../global/extensions/widgets.dart';
import '../../../../../global/icons.dart';
import '../../../../../global/utils/email_validator.dart';
import '../../../../../global/widgets/auto_scroll_view.dart';
import '../../../../../global/widgets/fetching_button.dart';
import '../../sign_in/view/widgets/password_field.dart';
import '../bloc/sign_up_bloc.dart';
import 'utils/send_sign_up_form.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});
  static const routeName = 'Sign Up';
  static const routePath = '/sign-up';

  @override
  Widget build(BuildContext context, ref) {
    final bloc = ref.watch(
      signUpProvider.select(
        (bloc) => bloc.fetching,
      ),
    );

    final state = bloc.state;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AbsorbPointer(
        absorbing: state.fetching,
        child: Form(
          child: AutoScrollView(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                texts.signUp.title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).center,
              const SizedBox(height: 20),
              Text(texts.signUp.fullName),
              const SizedBox(height: 5),
              TextFormField(
                textInputAction: TextInputAction.next,
                onChanged: (text) => signUpProvider.read().onFullNameChanged(text),
              ),
              const SizedBox(height: 20),
              Text(texts.signUp.email),
              const SizedBox(height: 5),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (text) => signUpProvider.read().onEmailChanged(text),
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
              PasswordTextField(
                textInputAction: TextInputAction.go,
                onChanged: (text) {
                  signUpProvider.read().onPasswordChanged(text);
                },
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => DefaultTabController.of(context).index = 0,
                    child: Row(
                      children: [
                        MeeduIcons.chevron_left.icon(),
                        Text(texts.misc.goBack),
                      ],
                    ),
                  ),
                  const SizedBox(width: 50),
                  Builder(
                    builder: (context) => FetchingButton(
                      fetching: state.fetching,
                      onPressed: () {
                        if (Form.of(context).validate()) {
                          sendSignUpForm(context);
                        }
                      },
                      text: texts.signUp.signUp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
