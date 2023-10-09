import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_meedu/providers.dart';

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
  Repositories.auth.setArguments(
    (auth: firebaseAuth, http: http),
  );

  Repositories.packages.setArguments(
    (
      saveFileService: saveFileService,
      cacheService: cacheService,
      packagesService: PackagesService(firebaseAuth, firestore),
      http: http,
      compressorService: compressorService,
    ),
  );

  Repositories.browserUtils.setArguments(
    browserService,
  );

  Repositories.apiKeys.setArguments(
    (
      auth: firebaseAuth,
      store: firestore,
      http: http,
    ),
  );
}

class Repositories {
  Repositories._();

  static final auth = ArgumentsProvider<AuthRepository, ({FirebaseAuth auth, Http http})>(
    (ref) => AuthRepositoryImpl(
      ref.arguments.auth,
      ref.arguments.http,
    ),
  );

  static final packages = ArgumentsProvider<
      PackagesRepository,
      ({
        PackagesService packagesService,
        Http http,
        SaveFileService saveFileService,
        CacheService cacheService,
        CompressorService compressorService,
      })>(
    (ref) => PackagesRepositoryImpl(
      packagesService: ref.arguments.packagesService,
      http: ref.arguments.http,
      saveFileService: ref.arguments.saveFileService,
      cacheService: ref.arguments.cacheService,
      compressorService: ref.arguments.compressorService,
    ),
  );

  static final browserUtils = ArgumentsProvider<BrowserUtilsRepository, BrowserWebService>(
    (ref) => BrowserUtilsRepositoryImpl(ref.arguments),
  );

  static final apiKeys = ArgumentsProvider<
      ApiKeysRepository,
      ({
        FirebaseAuth auth,
        FirebaseFirestore store,
        Http http,
      })>(
    (ref) => ApiKeysRepositoryImpl(
      ref.arguments.auth,
      ref.arguments.store,
      ref.arguments.http,
    ),
  );
}
