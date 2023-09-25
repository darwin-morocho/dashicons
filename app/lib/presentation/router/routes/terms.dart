part of '../router.dart';

class TermsAndPrivacyRoute extends AppRoute {
  static const path = '/terms-and-privacy';

  static GoRoute get _read => GoRoute(
        path: path,
        name: 'Terms and privacy',
        builder: (_, __) => const TermsAndPrivacyScreen(),
      );

  @override
  String get location => path;
}
