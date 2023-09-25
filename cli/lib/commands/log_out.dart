import 'dart:async';

import 'package:args/command_runner.dart';

import '../domain/repositories/auth_repositoty.dart';
import '../utils/loader.dart';

class LogOutCommand extends Command<void> {
  final AuthRepository _repository;

  LogOutCommand(this._repository);

  @override
  String get description => 'Remove the current session data';

  @override
  String get name => 'logout';

  @override
  Future<void> run() async {
    await showLoader(
      _repository.logout(),
    );
    print('😏 logout sucessful');
  }
}
