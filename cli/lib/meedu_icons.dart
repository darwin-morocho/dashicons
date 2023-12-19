import 'package:args/command_runner.dart';
import 'package:http/http.dart';

import 'commands/init.dart';
import 'commands/log_out.dart';
import 'commands/login.dart';
import 'commands/pull.dart';
import 'data/http.dart';
import 'inject_repositories.dart';

class Commands extends CommandRunner<void> {
  Commands(super.executableName, super.description) {
    injectRepositories(
      http: Http(
        'https://cloudicons.meedu.app',
        Client(),
      ),
    );
    addCommand(
      LoginCommand(Repositories.auth.read()),
    );
    addCommand(
      LogOutCommand(Repositories.auth.read()),
    );
    addCommand(
      InitCommand(Repositories.auth.read(), Repositories.packages.read()),
    );
    addCommand(PullCommand(Repositories.packages.read())
      ..argParser.addOption(
        'file',
        help: '''
You can use the file argument to use a different config file. Useful when you have multiple packages in one single project.
''',
      )
      ..argParser.addOption(
        'useApiKey',
        help: '''
Use useApiKey=true if you are running a CI/CD process.
Keep in mind that you must define an environment variable called MICONS_API_KEY with your API key.
''',
      )
      ..argParser.addOption(
        'MICONS_API_KEY',
        help: '''
Your api key
''',
      ));
  }
}
