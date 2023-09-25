import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../global/extensions/widgets.dart';
import '../../../global/widgets/max_size.dart';
import '../submodules/api_keys/view/api_keys_view.dart';

enum AccountSettings { apiKeys, billing }

class AccountSettingsScreen extends HookWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxSize(
      width: 1200,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Material(
                elevation: 0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ).paddingAll(20),
          ),
          const Expanded(
            flex: 5,
            child: ApiKeysView(),
          ),
        ],
      ),
    );
  }
}
