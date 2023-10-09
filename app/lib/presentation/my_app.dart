import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:flutter_meedu/providers.dart';

import 'generated/translations.g.dart';
import 'global/blocs/session/session_bloc.dart';
import 'global/theme/light_theme.dart';
import 'global/widgets/loader.dart';
import 'modules/splash/view/splash_view.dart';
import 'router/router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, BuilderRef ref) {
    final initialized = ref.select(
      sessionProvider.select(
        (bloc) => bloc.initialized,
      ),
    );

    if (initialized) {
      return MaterialApp.router(
        locale: TranslationProvider.of(context).flutterLocale,
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: routerProvider.read(),
        theme: lightTheme,
        builder: (_, child) => Loader(child: child),
      );
    }

    return const SplashView();
  }
}
