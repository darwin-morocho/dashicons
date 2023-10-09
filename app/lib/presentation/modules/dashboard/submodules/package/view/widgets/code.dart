import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:flutter_meedu/screen_utils.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/extensions/sized_box.dart';
import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/icons.dart';
import '../../../../../../global/theme/colors.dart';
import '../../bloc/package_bloc.dart';
import '../utils/get_config.dart';

class CodeViewer extends ConsumerWidget {
  const CodeViewer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final code = getDarCode(ref.watch(packageProvider).state.package);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          10.h,
          Card(
            elevation: 0,
            color: Colors.white,
            child: Column(
              children: [
                Text(texts.package.cli.label),
                10.h,
                ElevatedButton.icon(
                  onPressed: () => launchUrlString(
                    'https://pub.dev/packages/micons_cli',
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: MeeduIcons.terminal.icon(),
                  label: Text(texts.package.cli.install),
                ),
              ],
            ).paddingAll(20),
          ).fullWidth,
          20.h,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: AppColors.dark,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Markdown(
                      data: '''
```
$code
```
''',
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        code: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                          fontFamily: context.textTheme.bodyMedium?.fontFamily,
                        ),
                        codeblockDecoration: const BoxDecoration(
                          color: AppColors.dark,
                        ),
                      ),
                      extensionSet: md.ExtensionSet(
                        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                        [
                          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: code,
                          ),
                        );
                        showSimpleNotification(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MeeduIcons.done_all.icon(),
                              10.w,
                              Text(
                                texts.package.copied,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          position: NotificationPosition.bottom,
                          background: AppColors.blue,
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          AppColors.darkLight,
                        ),
                      ),
                      icon: const Icon(Icons.copy_outlined),
                      label: Text(texts.package.copy),
                    ),
                  ),
                ],
              ),
            ),
          ).expanded,
        ],
      ),
    );
  }
}
