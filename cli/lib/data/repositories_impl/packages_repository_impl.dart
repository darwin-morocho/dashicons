import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../../domain/models/package.dart';
import '../../domain/models/session.dart';
import '../../domain/models/svg_icon.dart';
import '../../domain/repositories/packages_repository.dart';
import '../http.dart';
import '../services/auth_service.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final Http _http;
  final AuthService _authService;

  PackagesRepositoryImpl(this._http, this._authService);

  @override
  Future<List<Package>?> getPackages(Session session) async {
    final result = await _http.send(
      '/api/v1/cli/get-projects',
      headers: {
        'authorization': 'Bearer ${session.idToken}',
      },
      parser: (_, json) => (json['packages'] as List)
          .map(
            (e) => Package.fromJson(e),
          )
          .toList(),
    );
    return result.when(
      success: (_, packages) => packages,
      failed: (_, __) => null,
    );
  }

  @override
  Future<Package?> getPackage(
    String packageId, {
    String? apiKey,
  }) async {
    final idToken = (await _authService.session)?.idToken;

    if (idToken == null && apiKey == null) {
      return null;
    }

    final result = await _http.send(
      '/api/v1/cli/get-project/$packageId',
      headers: {
        if (apiKey == null)
          'Authorization': 'Bearer $idToken'
        else
          'api-key': apiKey
      },
      parser: (_, json) => Package.fromJson(json['package']),
    );
    return result.when(
      success: (_, package) => package,
      failed: (_, __) => null,
    );
  }

  @override
  Future<Uint8List?> downloadSelectedIconsFont(
    Package package, {
    String? apiKey,
  }) async {
    try {
      final result = await _http.send(
        '/api/v1/parse-svgs',
        headers: {
          if (apiKey == null)
            'Authorization': 'Bearer ${(await _authService.session)?.idToken}'
          else
            'api-key': apiKey
        },
        method: HttpMethod.post,
        autoDecodeReponse: false,
        body: {
          'fontName': package.fontFamily,
          'data': package.icons
              .where((e) => e.selected)
              .map(
                (e) => {
                  'id': e.id,
                  'svg': e.toStringNormalized(),
                },
              )
              .toList(),
        },
        parser: (_, bytes) => (bytes as Uint8List).buffer.asUint8List(),
      );
      return result.when(
        success: (_, bytes) => bytes,
        failed: (_, __) => null,
      );
    } catch (e, s) {
      print(e);
      print(s);
    }
    return null;
  }
}

extension _SvgExt on SvgIcon {
  String toStringNormalized() {
    final decoder = GZipDecoder();
    // Decode the encoded bytes from base64
    final decodedBytes = base64.decode(path);

    // Decode the compressed bytes using gzip decompression
    final decodedPath = utf8.decode(decoder.decodeBytes(decodedBytes));
    return '<svg height="48" viewBox="0 96 960 960" width="48"><path d="$decodedPath"/></svg>';
  }
}
