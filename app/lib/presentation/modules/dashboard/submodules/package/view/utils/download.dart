import 'package:flutter/widgets.dart';

import '../../../../../../../domain/use_cases/packages/download_backup.dart';
import '../../../../../../../domain/use_cases/packages/download_fft.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../../../global/widgets/loader.dart';
import '../../bloc/package_bloc.dart';

Future<void> downloadFontIcons(BuildContext context) async {
  final package = packageProvider.read.state.package;

  if (package.icons.isNotEmpty) {
    await Loader.show(
      context,
      DownloadFontUseCase(Repositories.packages)(package),
    );
  }
}

void downloadBackup(BuildContext context) {
  final package = packageProvider.read.state.package;

  if (package.icons.isNotEmpty) {
    DownloadBackupUseCase(Repositories.packages)(package);
  }
}
