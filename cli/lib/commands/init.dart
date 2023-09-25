import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../domain/models/package.dart';
import '../domain/repositories/auth_repositoty.dart';
import '../domain/repositories/packages_repository.dart';
import '../utils/loader.dart';

class InitCommand extends Command<void> {
  final AuthRepository _authRepository;
  final PackagesRepository _packagesRepository;

  InitCommand(this._authRepository, this._packagesRepository);

  @override
  String get description =>
      'Initialize the icons.meedu.app project in the current directory';

  @override
  String get name => 'init';

  @override
  Future<void>? run() async {
    try {
      final session = await showLoader(_authRepository.session);
      if (session == null) {
        throw Exception('❌ Unathorized: You must 👉 run micons login 👈');
      }

      final packages = await showLoader(
        _packagesRepository.getPackages(session),
      );
      if (packages == null) {
        throw Exception('❌ Your request could not be processed');
      }
      final package = menu<Package>(
        fromStart: false,
        prompt: '🤠 Witch package do you want to use?',
        options: packages,
        format: (package) => '${package.name} - ${package.fontFamily}',
      );

      final ttfFile = '${package.fontFamily}.ttf';
      final iconsFile = 'icons.dart';

      final ttfDir = ask(
        'Where do you want to save your $ttfFile file? (default: assets/icons/): ',
        defaultValue: 'assets/icons/',
      ).trim();
      final iconsDir = ask(
        'Where do you want to save your $iconsFile file? (example: lib/presentation/global/): ',
      ).trim();

      final ttfPath = join(ttfDir, ttfFile);
      final iconsPath = join(iconsDir, iconsFile);

      final config = {
        'id': package.id,
        'ttfFile': ttfPath,
        'dartFile': iconsPath,
      };
      'micons.json'.write(
        JsonEncoder.withIndent('  ').convert(config),
      );
      if (!exists(ttfDir)) {
        createDir(ttfDir, recursive: true);
      }

      if (!exists(iconsDir)) {
        createDir(iconsDir, recursive: true);
      }

      iconsPath.write('');
      iconsPath.write('');
      print("""


✅ micons.json created

IMPORTANT: 
You should add and commit your generated files

Example:

git add micons.json $ttfPath $iconsPath
git commit -m "meedu icons initialized"

Keep in mind that those file $ttfPath and $iconsPath will be replaced using code generation so you should ignore your ttf file and your dart file for future commits to avoid commit merge conflicts.

Example in your .gitignore add the next 2 lines

$ttfPath
$iconsPath

Now go to your pubspec.yaml and add the font configuration
flutter:
  fonts:
   - family: ${package.fontFamily}
     fonts:
      - asset: $ttfPath


FINALLY
You can use the next command to generate your files

micons pull

""");
      exit(0);
    } catch (e) {
      print(e);
      exit(1);
    }
  }
}
