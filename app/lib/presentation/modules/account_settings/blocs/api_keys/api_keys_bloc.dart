import 'dart:async';

import 'package:flutter_meedu/notifiers.dart';
import 'package:flutter_meedu/providers.dart';

import '../../../../../domain/models/api_key.dart';
import '../../../../../domain/use_cases/api_keys/on_changed.dart';
import '../../../../dependency_injection.dart';

final apiKeysProvider = StateNotifierProvider<ApiKeysBloc, List<ApiKey>>(
  (_) => ApiKeysBloc(
    [],
    OnApiKeysChangedUseCase(
      Repositories.apiKeys.read(),
    ),
  )..init(),
);

class ApiKeysBloc extends StateNotifier<List<ApiKey>> {
  ApiKeysBloc(
    super.initialState,
    this._onApiKeysChangedUseCase,
  );

  late final StreamSubscription _subscription;
  final OnApiKeysChangedUseCase _onApiKeysChangedUseCase;

  void init() {
    _subscription = _onApiKeysChangedUseCase().listen(_listener);
  }

  void _listener(List<ApiKey> apiKeys) {
    state = apiKeys;
  }

  @override
  FutureOr<void> dispose() {
    _subscription.cancel();
    return super.dispose();
  }
}
