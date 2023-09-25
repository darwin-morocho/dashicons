import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_meedu/meedu.dart';

import '../data/http.dart';
import '../data/repositories_impl/api_keys_repository.dart';
import '../data/repositories_impl/auth_repository_impl.dart';
import '../data/repositories_impl/browser_utils_repository_impl.dart';
import '../data/repositories_impl/packages_repository_impl.dart';
import '../data/services/compressor/compressor_service.dart';
import '../data/services/local/browser/browser_web_service.dart';
import '../data/services/local/cache/cache_service.dart';
import '../data/services/local/save_file_service/save_file_service.dart';
import '../data/services/remote/packages_service.dart';
import '../domain/repositories/api_keys_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/browser_utils_repository.dart';
import '../domain/repositories/packages_repository.dart';

void injectDependencies({
  required FirebaseAuth firebaseAuth,
  required FirebaseFirestore firestore,
  required Http http,
  required SaveFileService saveFileService,
  required ZipDecoder zipDecoder,
  required BrowserWebService browserService,
  required CacheService cacheService,
  required CompressorService compressorService,
}) {
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth, http),
  );

  Get.lazyPut<PackagesRepository>(
    () => PackagesRepositoryImpl(
      saveFileService: saveFileService,
      cacheService: cacheService,
      packagesService: PackagesService(firebaseAuth, firestore),
      http: http,
      compressorService: compressorService,
    ),
  );

  Get.lazyPut<BrowserUtilsRepository>(
    () => BrowserUtilsRepositoryImpl(browserService),
  );

  Get.lazyPut<ApiKeysRepository>(
    () => ApiKeysRepositoryImpl(
      firebaseAuth,
      firestore,
      http,
    ),
  );
}

class Repositories {
  Repositories._();

  static AuthRepository get auth => Get.find();
  static PackagesRepository get packages => Get.find();
  static BrowserUtilsRepository get browserUtils => Get.find();
  static ApiKeysRepository get apiKeys => Get.find();
}
