import 'package:meedu/providers.dart';

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
  Repositories.auth.setArguments(
    (http: http, authService: authService),
  );
  Repositories.packages.setArguments(
    (http: http, authService: authService),
  );
}

class Repositories {
  Repositories._();

  static final auth = Provider.arguments<
      AuthRepository,
      ({
        Http http,
        AuthService authService,
      })>(
    (ref) => AuthRepositoryImpl(
      ref.arguments.http,
      ref.arguments.authService,
    ),
  );
  static final packages = Provider.arguments<
      PackagesRepository,
      ({
        Http http,
        AuthService authService,
      })>(
    (ref) => PackagesRepositoryImpl(
      ref.arguments.http,
      ref.arguments.authService,
    ),
  );
}
