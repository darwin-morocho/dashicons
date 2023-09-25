import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../domain/repositories/auth_repositoty.dart';
import '../utils/loader.dart';

class LoginCommand extends Command<void> {
  final AuthRepository _authRepository;

  LoginCommand(this._authRepository);

  @override
  String get description => "Login in your icons.meedu.app account";

  @override
  String get name => 'login';

  @override
  Future<void>? run() async {
    try {
      print('Enter your email');
      final email = ask('email:');

      if (!isValidEmail(email)) {
        throw Exception('❌ Invalid email');
      }

      final result = await showLoader(
        _authRepository.requestCredentials(email),
      );
      result.whenOrNull(
        failed: (statusCode, data) {
          throw Exception(
            '$statusCode: ${data is Map ? data['message'] : 'Internal error'}',
          );
        },
      );

      print(
        '✅ We have sent an email with your auth credentials\nEnter your credentials',
      );

      final sessionResult = await showLoader(
        _authRepository.sendCredentials(
          email: email,
          apiKey: ask('apiKey:').trim(),
          oobCode: ask('oobCode:').trim(),
        ),
      );

      sessionResult.whenOrNull(
        failed: (statusCode, data) {
          throw Exception(
            '$statusCode: ${data is Map ? data['message'] : 'Internal error'}',
          );
        },
      );

      print('✅ Session saved');
      exit(0);
    } catch (e) {
      print(e);
      exit(1);
    }
  }
}

bool isValidEmail(String text) => RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(text);
