import 'package:sembast/sembast.dart';

import '../../../../domain/models/font_cache.dart';

class CacheService {
  CacheService(this._store, this._database);

  final StoreRef<String, Map<String, Object?>> _store;
  final Database _database;

  Future<void> saveFont(FontCache cache) async {
    if (await _store.record(cache.packageId).exists(_database)) {
      await _store.record(cache.packageId).update(_database, cache.toJson());
    } else {
      await _store.record(cache.packageId).add(_database, cache.toJson());
    }
  }

  Future<FontCache?> getById(String packageId) async {
    try {
      final json = await _store.record(packageId).get(_database);

      if (json != null) {
        return FontCache.fromJson(json);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() => _store.delete(_database);
}
