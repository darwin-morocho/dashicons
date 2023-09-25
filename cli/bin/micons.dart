import 'package:micons_cli/meedu_icons.dart';

void main(List<String> arguments) {
  final command = Commands(
    'micons',
    'The oficial Dart CLI for icons.meedu.app',
  );
  command.run(arguments);
}
