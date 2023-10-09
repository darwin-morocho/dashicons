import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../../../domain/models/svg_icon.dart';
import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/theme/colors.dart';
import '../../../../../../global/utils/input_formatters.dart';
import '../../../../../../global/widgets/secondary_button.dart';
import '../../bloc/package_bloc.dart';

Future<void> showEditIconNamePopup(
  BuildContext context,
  SvgIcon icon,
  String fontFamily,
) async {
  final name = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => EditIconNamePopUp(
      icon: icon,
      fontFamily: fontFamily,
    ),
  );

  if (name == null || icon.name == name || name.isEmpty) {
    return;
  }

  final bloc = packageProvider.read();
  bool duplicated = false;
  for (final icon in bloc.state.package.icons) {
    if (icon.name == name) {
      duplicated = true;
      break;
    }
  }

  if (duplicated) {
    toast(texts.package.failures.duplicatedName);
    return;
  }

  bloc.onChangeName(icon, name);
}

class EditIconNamePopUp extends HookWidget {
  const EditIconNamePopUp({
    super.key,
    required this.icon,
    required this.fontFamily,
  });

  final SvgIcon icon;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    final name = useState(icon.name);
    final textEditingController = useTextEditingController(text: icon.name);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(
            icon.charCode,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 50,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: textEditingController,
            autocorrect: false,
            onChanged: (text) => name.value = text.trim(),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z_]')),
              FirstLetterTextInputFormatter(),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              SecondaryButton.text(
                texts.misc.cancel,
                onPressed: () => Navigator.pop(context),
                textStyle: const TextStyle(
                  color: AppColors.red,
                ),
              ).expanded,
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, name.value),
                child: Text(texts.misc.update),
              ).expanded,
            ],
          ),
        ],
      ),
    );
  }
}
