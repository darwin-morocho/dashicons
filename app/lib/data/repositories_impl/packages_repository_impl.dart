import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../domain/models/font_cache.dart';
import '../../domain/models/package.dart';
import '../../domain/models/svg_icon.dart';
import '../../domain/repositories/packages_repository.dart';
import '../http.dart';
import '../services/compressor/compressor_service.dart';
import '../services/local/cache/cache_service.dart';
import '../services/local/save_file_service/save_file_service.dart';
import '../services/remote/packages_service.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  PackagesRepositoryImpl({
    required PackagesService packagesService,
    required Http http,
    required SaveFileService saveFileService,
    required CacheService cacheService,
    required CompressorService compressorService,
  })  : _http = http,
        _saveFileService = saveFileService,
        _packagesService = packagesService,
        _cacheService = cacheService,
        _compressorService = compressorService;

  final SaveFileService _saveFileService;
  final PackagesService _packagesService;
  final CacheService _cacheService;
  final CompressorService _compressorService;
  final Http _http;

  @override
  Future<void> downloadSelectedIconsFont(Package package) async {
    try {
      final result = await _http.send(
        '/api/v1/parse-svgs',
        headers: {
          'Authorization': 'Bearer ${await _packagesService.idToken}',
        },
        method: HttpMethod.post,
        autoDecodeReponse: false,
        body: {
          'fontName': package.fontFamily,
          'data': package.icons
              .where((e) => e.selected)
              .map((e) => {'id': e.id, 'svg': e.toStringNormalized(_compressorService)})
              .toList(),
        },
        parser: (_, bytes) => (bytes as Uint8List).buffer.asUint8List(),
      );
      if (result is HttpSuccess<Uint8List>) {
        await _saveFileService.saveFile(
          '${package.fontFamily}.ttf',
          result.data,
        );
      }
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
    }
  }

  @override
  Future<void> downloadBackup(Package package) async {
    await _saveFileService.saveFile(
      'backup.json',
      Uint8List.fromList(
        utf8.encode(
          const JsonEncoder.withIndent('  ').convert(
            package.toJson(),
          ),
        ),
      ),
    );
  }

  @override
  Future<Package?> createPackage(Package package) => _packagesService.createPackage(package);

  @override
  Future<List<Package>?> getPackages() => _packagesService.getPackages();

  @override
  Future<bool> updatePackage(Package package) async {
    return _packagesService.updatePackage(package);
  }

  @override
  Stream<Package> listenPackageChanges(String packageId) =>
      _packagesService.listenPackageChanges(packageId);

  @override
  Future<FontCache?> getFontCache(Package package) async {
    var cache = await _cacheService.getById(package.id);

    if (cache?.lastId == package.lastId) {
      return cache;
    }

    cache = await _downloadCache(package);
    if (cache != null) {
      await _cacheService.saveFont(cache);
    }
    return cache;
  }

  Future<FontCache?> _downloadCache(Package package) async {
    final result = await _http.send(
      '/api/v1/parse-svgs',
      headers: {
        'Authorization': 'Bearer ${await _packagesService.idToken}',
      },
      method: HttpMethod.post,
      autoDecodeReponse: false,
      body: {
        'fontName': package.fontFamily,
        'data': package.icons
            .map((e) => {'id': e.id, 'svg': e.toStringNormalized(_compressorService)})
            .toList(),
      },
      parser: (_, bytes) => (bytes as Uint8List).buffer.asUint8List(),
    );
    if (result is HttpSuccess<Uint8List>) {
      final cache = FontCache(
        packageId: package.id,
        base64Ttf: base64.encode(result.data),
        lastId: package.lastId,
      );
      await _cacheService.saveFont(cache);
      return cache;
    }
    return null;
  }

  @override
  String compressSvgPath(String plainText) {
    return _compressorService.compress(plainText);
  }

  @override
  String decodeCompressedSvgPath(String base64String) {
    return _compressorService.decode(base64String);
  }

  @override
  Future<void> downloadSvgIcon(SvgIcon icon) async {
    await _saveFileService.saveFile(
      '${icon.name}.svg',
      Uint8List.fromList(
        utf8.encode(
          icon.toStringNormalized(_compressorService),
        ),
      ),
    );
  }
}

extension _SvgExt on SvgIcon {
  String toStringNormalized(CompressorService compressorService) {
    return '<svg height="48" viewBox="0 96 960 960" width="48"><path d="${compressorService.decode(path)}"/></svg>';
  }
}
