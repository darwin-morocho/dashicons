import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

import '../domain/repositories/packages_repository.dart';
import '../utils/get_config.dart';
import '../utils/loader.dart';

class PullCommand extends Command<void> {
  final PackagesRepository _packagesRepository;

  PullCommand(this._packagesRepository);

  @override
  String get description =>
      'Pull the ttf file and update the icons.dart file with the latest package changes from icons.meedu.app';

  @override
  String get name => 'pull';

  @override
  Future<void> run() async {
    try {
      String? apiKey;
      if (argResults?['useApiKey'] == 'true') {
        apiKey = argResults?['MICONS_API_KEY'] as String?;
      }

      if (apiKey != null && apiKey.isEmpty) {
        throw Exception('❌ invalid apiKey');
      }

      var fileName = argResults?['file'] as String?;

      if (fileName != null && !fileName.endsWith('.json')) {
        throw Exception('❌ invalid config file -  $fileName');
      }

      fileName = fileName ?? 'micons.json';

      final configFile = File(fileName);

      if (!await configFile.exists()) {
        throw Exception('❌ $fileName file not found');
      }

      final config = jsonDecode(
        await showLoader(
          configFile.readAsString(),
        ),
      ) as Map<String, dynamic>;

      final keys = config.keys;
      if (!keys.contains('id') ||
          !keys.contains('ttfFile') ||
          !keys.contains('dartFile')) {
        throw Exception('❌ invalid config file -  $fileName');
      }

      final package = await showLoader(
        _packagesRepository.getPackage(
          config['id'],
          apiKey: apiKey,
        ),
      );

      if (package == null) {
        throw Exception('❌ Your request could not be processed');
      }

      final bytes = await showLoader(
        _packagesRepository.downloadSelectedIconsFont(
          package,
          apiKey: apiKey,
        ),
      );

      if (bytes == null) {
        throw Exception('❌ Your request could not be processed');
      }

      final ttfFile = File(config['ttfFile']);
      final dartFile = File(config['dartFile']);

      if (!ttfFile.existsSync()) {
        await ttfFile.create(recursive: true);
      }
      if (!dartFile.existsSync()) {
        await dartFile.create(recursive: true);
      }

      ttfFile.writeAsBytesSync(bytes);
      dartFile.writeAsStringSync(getDarCode(package));

      print('✅ pull sucessful');
      exit(0);
    } catch (e, _) {
      print(e);
      print(
          'Try login again using `micons logout` and `micons login` or checking your apiKey');
      print(_);
      exit(1);
    }
  }
}
