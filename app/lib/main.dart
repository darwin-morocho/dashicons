import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:url_strategy/url_strategy.dart';

import 'data/http.dart';
import 'data/services/compressor/compressor_service.dart';
import 'data/services/local/browser/browser_web_service.dart';
import 'data/services/local/cache/cache_service.dart';
import 'data/services/local/save_file_service/save_file_macos_service.dart';
import 'data/services/local/save_file_service/save_file_web_service.dart';
import 'firebase_options.dart';
import 'presentation/dependency_injection.dart';
import 'presentation/generated/translations.g.dart';
import 'presentation/my_app.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'meedu-icons',
  );

  late Database database;
  if (kIsWeb) {
    database = await databaseFactoryWeb.openDatabase('cache.db');
  } else {
    final appDir = await getApplicationSupportDirectory();
    database = await databaseFactoryIo.openDatabase(
      join(appDir.path, 'cache.db'),
    );
  }
  GoRouter.optionURLReflectsImperativeAPIs = true;

  injectDependencies(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    http: Http(
      const String.fromEnvironment('apiHost'),
      Client(),
    ),
    cacheService: CacheService(
      StoreRef.main(),
      database,
    ),
    saveFileService: kIsWeb ? SaveFileWebService() : SaveFileMacOsSerive(),
    browserService: BrowserWebService(),
    zipDecoder: ZipDecoder(),
    compressorService: CompressorService(),
  );

  runApp(
    TranslationProvider(
      child: const OverlaySupport.global(
        child: MyApp(),
      ),
    ),
  );
}
