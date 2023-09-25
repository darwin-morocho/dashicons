import 'package:path/path.dart';
import 'package:xml/xml.dart';

import '../../../../../../../domain/models/svg_icon.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../../../generated/translations.g.dart';
import '../../bloc/package_bloc.dart';

(List<String>, List<SvgIcon>) svgParser(List<SvgData> items) {
  final svgs = <SvgIcon>[];
  final errors = <String>[];

  final bloc = packageProvider.read;

  final names = bloc.state.package.icons.map((e) => e.name).toList();
  int index = bloc.state.package.lastId;

  for (final item in items) {
    final fileName = item.fileName.replaceAll('-', '_');
    final svgAsString = item.svgAsString;

    final document = XmlDocument.parse(svgAsString);

    final paths = document.findAllElements('path');
    final path = paths.isNotEmpty ? paths.first.getAttribute('d') : null;

    if (path == null) {
      errors.add(
        texts.package.failures.upload.pathNotFound(fileName: fileName),
      );
      continue;
    }

    if (paths.length > 1) {
      errors.add(
        texts.package.failures.upload.multiPath(fileName: fileName),
      );
      continue;
    }

    var name = basenameWithoutExtension(fileName);

    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(name)) {
      errors.add(
        texts.package.failures.upload.invalidFileName(fileName: fileName),
      );
      continue;
    }
    name = name.toLowerCase().trim();

    /// duplicated name
    if (names.contains(name)) {
      name += '_duplicated_name';
    }

    index++;
    svgs.add(
      SvgIcon(
        id: index,
        name: name,
        path: Repositories.packages.compressSvgPath(path),
      ),
    );
  }
  return (errors, svgs);
}

class SvgData {
  SvgData({
    required this.fileName,
    required this.svgAsString,
  });

  final String fileName;
  final String svgAsString;
}

String getPathFromSvgString(String svg) {
  final document = XmlDocument.parse(svg);
  final paths = document.findAllElements('path');

  if (paths.isEmpty || paths.first.getAttribute('d') == null) {
    throw AssertionError('The provided svg does not contains a valid path');
  }
  return paths.first.getAttribute('d')!;
}
