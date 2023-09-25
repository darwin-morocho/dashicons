import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/models/package.dart';

class PackagesService {
  PackagesService(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  String get _userId => _firebaseAuth.currentUser!.uid;
  Future<String?> get idToken => _firebaseAuth.currentUser!.getIdToken();

  Future<Package?> createPackage(Package package) async {
    try {
      final document = await _firestore.collection('packages').add(
        {
          'userId': _userId,
          ...package.toJson(),
        },
      );

      return package.copyWith(id: document.id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Package>?> getPackages() async {
    try {
      final query = await _firestore
          .collection('packages')
          .where(
            'userId',
            isEqualTo: _userId,
          )
          .get();
      if (query.docs.isEmpty) {
        return [];
      }
      return query.docs.map(
        (snapshot) {
          return Package.fromJson(
            {
              ...snapshot.data(),
              'id': snapshot.id,
            },
          );
        },
      ).toList();
    } catch (e) {
      log(e.toString(), error: e);
      return null;
    }
  }

  Future<bool> updatePackage(Package package) async {
    try {
      var lastId = package.lastId;
      if (package.icons.isNotEmpty) {
        lastId = math.max(package.icons.map((e) => e.id).reduce(math.max), lastId);
      }
      await _firestore.collection('packages').doc(package.id).set(
        {
          'userId': _userId,
          ...package.toJson(),
          'lastId': lastId,
        },
      );
      return true;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      return false;
    }
  }

  Stream<Package> listenPackageChanges(String packageId) {
    return _firestore.collection('packages').doc(packageId).snapshots().transform<Package>(
      StreamTransformer.fromHandlers(
        handleData: (snapshot, sink) {
          if (!snapshot.exists) {
            return;
          }
          sink.add(
            Package.fromJson(
              {
                ...snapshot.data()!,
                'id': snapshot.id,
              },
            ),
          );
        },
      ),
    );
  }
}
