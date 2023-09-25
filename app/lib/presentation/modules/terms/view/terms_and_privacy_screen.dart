import 'package:flutter/material.dart';

import '../../../generated/translations.g.dart';
import '../../../global/extensions/sized_box.dart';
import '../../../global/extensions/widgets.dart';
import '../../../global/widgets/main_scaffold/main_app_scaffold.dart';
import '../../../global/widgets/max_size.dart';

class TermsAndPrivacyScreen extends StatelessWidget {
  const TermsAndPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      child: MaxSize(
        width: 1000,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: ListView(
                children: [
                  20.h,
                  ...texts.terms.terms.map(
                    (e) => Text(e).paddingOnly(top: 10),
                  ),
                  const Divider(),
                  ...texts.terms.privacy.map(
                    (e) => Text(e).paddingOnly(top: 10),
                  ),
                  20.h,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
