import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_meedu/screen_utils.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/icons.dart';
import '../../../../../../global/theme/colors.dart';

class PasswordTextField extends HookWidget {
  const PasswordTextField({
    super.key,
    required this.onChanged,
    this.textInputAction,
    this.onSubmitted,
  });
  final void Function(String) onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final visible = useState(false);

    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: '',
      validator: (text) {
        if (text!.contains(' ')) {
          return texts.signUp.invalidFields.password.blankSpaces;
        }

        if (text.length >= 6) {
          return null;
        }
        return texts.signUp.invalidFields.password.length;
      },
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 1,
            onSubmitted: onSubmitted,
            textInputAction: textInputAction,
            obscureText: !visible.value,
            decoration: InputDecoration(
              isDense: true,
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 20,
                minHeight: 20,
              ),
              suffixIcon: MaterialButton(
                minWidth: 25,
                padding: const EdgeInsets.all(4),
                height: 25,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onPressed: () => visible.value = !visible.value,
                child: (visible.value ? MeeduIcons.visibility_off : MeeduIcons.visibility).icon(),
              ),
            ),
            onChanged: (text) {
              state.didChange(text.trim());
              onChanged(text);
            },
          ),
          if (state.hasError && state.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 8),
              child: Text(
                state.errorText!,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
