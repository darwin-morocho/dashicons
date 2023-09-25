import 'package:meedu/get.dart';

import 'data/http.dart';
import 'data/repositories_impl/auth_repository_impl.dart';
import 'data/repositories_impl/packages_repository_impl.dart';
import 'data/services/auth_service.dart';
import 'domain/repositories/auth_repositoty.dart';
import 'domain/repositories/packages_repository.dart';

void injectRepositories({
  required Http http,
}) {
  final authService = AuthService(http);
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(http, authService),
  );
  Get.lazyPut<PackagesRepository>(
    () => PackagesRepositoryImpl(http, authService),
  );
}

class Repositories {
  Repositories._();

  static AuthRepository get auth => Get.find();
  static PackagesRepository get packages => Get.find();
}
