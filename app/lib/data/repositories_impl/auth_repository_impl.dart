import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';

import '../../domain/either.dart';
import '../../domain/failures/http_request_failure.dart';
import '../../domain/failures/sign_in_failure.dart';
import '../../domain/failures/sign_up_failure.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/typedefs.dart';
import '../http.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth, this._http);

  final firebase.FirebaseAuth _auth;
  final Http _http;

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<User?> get currentUser async =>
      _auth.currentUser != null ? _userFromFirebase(_auth.currentUser!) : null;

  @override
  FutureEither<SignInFailure, User> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Either.right(
        _userFromFirebase(_auth.currentUser!),
      );
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          return const Either.left(
            SignInFailure.network(),
          );
        case 'user-not-found':
          return const Either.left(
            SignInFailure.userNotFound(),
          );
        case 'wrong-password':
          return const Either.left(
            SignInFailure.invalidPassword(),
          );
        case 'user-disabled':
          return const Either.left(
            SignInFailure.disabled(),
          );
        case 'too-many-requests':
          return const Either.left(
            SignInFailure.tooManyRequests(),
          );
      }

      return const Either.left(
        SignInFailure.unhandledException(),
      );
    } catch (e) {
      return const Either.left(
        SignInFailure.unhandledException(),
      );
    }
  }

  @override
  FutureEither<SignUpFailure, User> signUp(User user, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      await _auth.currentUser!.sendEmailVerification();
      await _auth.currentUser!.updateDisplayName(
        user.fullName,
      );
      return Either.right(
        _userFromFirebase(_auth.currentUser!),
      );
    } on FirebaseException catch (e) {
      log(e.toString());
      switch (e.code) {
        case 'network-request-failed':
          return const Either.left(
            SignUpFailure.network(),
          );
        case 'email-already-in-use':
          return const Either.left(
            SignUpFailure.duplicatedEmail(),
          );
        case 'too-many-requests':
          return const Either.left(
            SignUpFailure.tooManyRequests(),
          );
      }

      return const Either.left(
        SignUpFailure.unhandledException(),
      );
    } catch (e) {
      log(e.toString());
      return const Either.left(
        SignUpFailure.unhandledException(),
      );
    }
  }

  @override
  FutureEither<SignUpFailure, User> signInWithGoogle() async {
    try {
      final googleProvider = firebase.GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      // Once signed in, return the UserCredential
      await _auth.signInWithPopup(googleProvider);
      return Either.right(
        _userFromFirebase(_auth.currentUser!),
      );
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          return const Either.left(
            SignUpFailure.network(),
          );
        case 'email-already-in-use':
          return const Either.left(
            SignUpFailure.duplicatedEmail(),
          );
        case 'too-many-requests':
          return const Either.left(
            SignUpFailure.tooManyRequests(),
          );
      }

      return const Either.left(
        SignUpFailure.unhandledException(),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return const Either.left(
        SignUpFailure.unhandledException(),
      );
    }
  }

  @override
  FutureEither<HttpRequestFailure, void> sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Either.right(null);
    } on FirebaseException catch (e, s) {
      log(e.toString(), stackTrace: s);
      switch (e.code) {
        case 'network-request-failed':
          return Either.left(
            HttpRequestFailure.network(),
          );
        case 'firebase_auth/user-not-found':
          return Either.left(
            HttpRequestFailure.notFound(),
          );
      }
      return Either.left(
        HttpRequestFailure.unhandledException(),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return Either.left(
        HttpRequestFailure.unhandledException(),
      );
    }
  }

  @override
  FutureEither<HttpRequestFailure, String> signInWithCLI({
    required String apiKey,
    required String oobCode,
    required String email,
  }) async {
    final result = await _http.send(
      '/api/v1/cli/sign-in',
      body: {
        'apiKey': apiKey,
        'email': email,
        'oobCode': oobCode,
      },
      method: HttpMethod.post,
      parser: (_, json) {
        return base64.encode(
          utf8.encode(json),
        );
      },
    );

    if (result is HttpSuccess<String>) {
      return Either.right(result.data);
    }

    return Either.left(
      HttpRequestFailure.unhandledException(),
    );
  }
}

User _userFromFirebase(firebase.User firebaseUser) {
  return User(
    id: firebaseUser.uid,
    fullName: firebaseUser.displayName ?? '',
    email: firebaseUser.email!,
    avatar: firebaseUser.photoURL,
  );
}
