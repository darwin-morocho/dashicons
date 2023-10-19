import 'dart:convert';
import 'dart:io';

import 'package:jwt_decode/jwt_decode.dart';

import '../../domain/models/http_result.dart';
import '../../domain/models/session.dart';
import '../http.dart';

File get tokenFile {
  // Get the user's home directory to store the token
  Directory homeDir = Directory.fromUri(
    Uri.parse(Platform.environment['HOME']!),
  );
  return File('${homeDir.path}/.meedu_icons/session');
}

class AuthService {
  AuthService(this._http);
  final Http _http;

  Future<void> saveSession(Session session) async {
    // Create the parent directory if it doesn't exist
    await tokenFile.parent.create(recursive: true);
    await tokenFile.writeAsString(
      jsonEncode(session.toJson()),
    );
  }

  Future<HttpResult<Session>> _refreshToken(Session session) {
    return _http.send(
      'https://securetoken.googleapis.com/v1/token',
      queryParameters: {
        'key': session.apiKey,
      },
      method: HttpMethod.post,
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': session.refreshToken
      },
      parser: (_, json) => Session.fromJson({
        ...json,
        'apiKey': session.apiKey,
        'refreshToken': json['refresh_token'],
        'expiresIn': json['expires_in'],
        'idToken': json['id_token'],
      }),
    );
  }

  Future<Session?> get session async {
    try {
      if (!await tokenFile.exists()) {
        return null;
      }

      final session = Session.fromJson(
        jsonDecode(
          await tokenFile.readAsString(),
        ),
      );

      final expiryDate = Jwt.getExpiryDate(session.idToken);

      final diff = expiryDate!.difference(DateTime.now()).inSeconds;

      if (diff >= 30) {
        return session;
      }

      /// token will expire soon
      /// it must be refreshed
      final result = await _refreshToken(session);
      return result.when(
        success: (_, session) async {
          await saveSession(session);
          return session;
        },
        failed: (_, __) async => null,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      if (await tokenFile.exists()) {
        await tokenFile.delete(recursive: true);
      }
    } catch (_) {}
  }
}
