import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:flutter_meedu/screen_utils.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/translations.g.dart';
import '../../../router/router.dart';
import '../../blocs/session/session_bloc.dart';
import '../../dialogs/context_menu.dart';
import '../../icons.dart';
import '../../theme/colors.dart';
import '../max_size.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(sessionProvider).state.user;
    if (user == null) {
      return const SizedBox.shrink();
    }
    return Material(
      elevation: 0,
      color: Colors.white,
      child: MaxSize(
        width: 1200,
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  DashboardRoute().go(context);
                }
              },
              child: Text(
                'DashIcons',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Consumer(
              builder: (context, ref, __) {
                final user = ref.watch(sessionProvider).state.user;
                if (user != null) {
                  final initials = () {
                    final parts = user.fullName.split(' ');
                    if (parts.length > 1) {
                      return parts[0][0] + parts[1][0];
                    }
                    return parts.first.substring(0, 2);
                  }();

                  return InkWell(
                    onTap: () => _showProfileMenu(context),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.darkLight,
                          foregroundImage: user.avatar != null
                              ? ExtendedNetworkImageProvider(
                                  user.avatar!,
                                )
                              : null,
                          child: Text(
                            initials,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        MeeduIcons.expand_more.icon(),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showProfileMenu(BuildContext context) async {
    final result = await showContextMenu(
      context: context,
      items: [
        PopupMenuItem(
          value: ProfileMenuOption.settings,
          child: Row(
            children: [
              MeeduIcons.manage_accounts.icon(),
              const SizedBox(width: 10),
              Text(texts.main.account.settings),
            ],
          ),
        ),
        PopupMenuItem(
          value: ProfileMenuOption.signOut,
          child: Row(
            children: [
              MeeduIcons.logout.icon(),
              const SizedBox(width: 10),
              Text(texts.main.account.signOut),
            ],
          ),
        )
      ],
    );

    // ignore: use_build_context_synchronously
    if (result == null || !context.mounted) {
      return;
    }

    switch (result) {
      case ProfileMenuOption.settings:
        AccountSettingsRoute().push(context);
        break;
      case ProfileMenuOption.signOut:
        await sessionProvider.read().signOut();
        if (context.mounted) {
          AuthRoute().go(context);
        }
        break;
    }
  }
}

enum ProfileMenuOption {
  settings,
  signOut,
}
