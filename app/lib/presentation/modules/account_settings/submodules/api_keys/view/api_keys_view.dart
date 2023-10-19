import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../../domain/use_cases/api_keys/delete.dart';
import '../../../../../../domain/use_cases/api_keys/generate.dart';
import '../../../../../dependency_injection.dart';
import '../../../../../generated/translations.g.dart';
import '../../../../../global/dialogs/confirm.dart';
import '../../../../../global/extensions/sized_box.dart';
import '../../../../../global/extensions/widgets.dart';
import '../../../../../global/icons.dart';
import '../../../../../global/theme/colors.dart';
import '../../../../../global/widgets/loader.dart';
import '../../../blocs/api_keys/api_keys_bloc.dart';

class ApiKeysView extends ConsumerWidget {
  const ApiKeysView({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final apiKeys = ref.watch(apiKeysProvider).state;
    return Column(
      children: [
        20.h,
        Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              Text(texts.accountSettings.apiKeys.note),
              if (apiKeys.length < 3) ...[
                10.h,
                ElevatedButton(
                  onPressed: () => _generateApiKey(context),
                  child: Text(texts.accountSettings.apiKeys.generate),
                ),
              ]
            ],
          ).paddingAll(20),
        ).fullWidth,
        20.h,
        Align(
          alignment: Alignment.centerRight,
          child: Text('${apiKeys.length}/3'),
        ).paddingOnly(
          right: 10,
          bottom: 10,
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, __) => 10.h,
            itemBuilder: (_, index) {
              final apiKey = apiKeys[index];
              return Material(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(builder: (context) {
                        return IconButton(
                          onPressed: () async {
                            final confirmed = await showConfirmContextMenu(
                              context: context,
                              message: texts.accountSettings.apiKeys.delete.label,
                              cancelText: texts.accountSettings.apiKeys.delete.cancel,
                              confirmText: texts.accountSettings.apiKeys.delete.delete,
                            );
                            if (context.mounted && confirmed) {
                              Loader.show(
                                context,
                                DeleteApiKeyUseCase(
                                  Repositories.apiKeys.read(),
                                )(apiKey.id),
                              );
                            }
                          },
                          icon: MeeduIcons.delete.icon(
                            color: AppColors.red,
                          ),
                        );
                      }),
                      20.w,
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: apiKey.key),
                          );
                          toast(texts.package.copied);
                        },
                        icon: Icons.copy_rounded.icon(
                          color: AppColors.dark,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                  title: Text(
                    '***************${apiKey.key.substring(apiKey.key.length - 20, apiKey.key.length)}',
                  ),
                ),
              );
            },
            itemCount: apiKeys.length,
          ),
        ),
      ],
    );
  }

  Future<void> _generateApiKey(BuildContext context) async {
    await Loader.show(
      context,
      GenerateApiKeyUseCase(
        Repositories.apiKeys.read(),
      )(),
    );
  }
}
