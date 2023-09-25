import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/either.dart';
import '../../domain/failures/http_request_failure.dart';
import '../../domain/models/api_key.dart';
import '../../domain/repositories/api_keys_repository.dart';
import '../../domain/typedefs.dart';
import '../http.dart';

class ApiKeysRepositoryImpl implements ApiKeysRepository {
  ApiKeysRepositoryImpl(this._firebaseAuth, this._firestore, this._http);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Http _http;

  String get _userId => _firebaseAuth.currentUser!.uid;
  Future<String?> get _idToken => _firebaseAuth.currentUser!.getIdToken();

  @override
  FutureEither<HttpRequestFailure, String> generate() async {
    final result = await _http.send(
      '/api/v1/auth/generate-api-key',
      headers: {
        'Authorization': 'Bearer ${await _idToken}',
      },
      parser: (_, json) => json['key'] as String,
    );

    if (result is HttpSuccess<String>) {
      return Either.right(result.data);
    }

    late final HttpRequestFailure failure;
    switch (result.statusCode) {
      case 404:
        failure = HttpRequestFailure.notFound();
        break;

      case 401:
        failure = HttpRequestFailure.unauthorized();
        break;

      default:
        failure = HttpRequestFailure.unhandledException();
    }

    return Either.left(failure);
  }

  @override
  Stream<List<ApiKey>> get onChanged {
    return _firestore
        .collection('apiKeys')
        .where('uid', isEqualTo: _userId)
        .snapshots()
        .transform<List<ApiKey>>(
      StreamTransformer.fromHandlers(
        handleData: (snapshot, sink) {
          sink.add(
            snapshot.docs
                .where((e) => e.exists)
                .map(
                  (e) => ApiKey.fromJson({
                    ...e.data(),
                    'id': e.id,
                  }),
                )
                .toList(),
          );
        },
      ),
    );
  }

  @override
  FutureEither<HttpRequestFailure, List<ApiKey>> getApiKeys() async {
    try {
      final snapshot = await _firestore
          .collection('apiKeys')
          .where(
            'uid',
            isEqualTo: _userId,
          )
          .get();
      return Either.right(
        snapshot.docs
            .where((e) => e.exists)
            .map(
              (e) => ApiKey.fromJson({
                ...e.data(),
                'id': e.id,
              }),
            )
            .toList(),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return Either.left(
        HttpRequestFailure.unhandledException(),
      );
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      await _firestore.collection('apiKeys').doc(id).delete();
      return true;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return false;
    }
  }
}
