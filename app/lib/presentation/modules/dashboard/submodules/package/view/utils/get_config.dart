import '../../../../../../../domain/models/package.dart';

String getDarCode(Package package) {
  final fontFamily = package.fontFamily;
  final fontPackage = package.fontPackage ?? '';

  var dartFileAsString = '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: constant_identifier_names

/// To use this font, place it in your fonts/ directory and include the
/// following in your pubspec.yaml
///
/// flutter:
///   fonts:
///    - family: $fontFamily
///      fonts:
///       - asset: fonts/$fontFamily.ttf
/// 
/// 
/// 👉 IMPORTANT: 👈
/// On web when we use the Icon Widget to display our custom icons
/// for some reason flutter unnecessarily adds a line-height
/// that causes our icons to not be centered correctly
/// to fix this and for our icons to display correctly
/// on iOS, Android, web, macOS, linux and windows we can use
/// the FontIcon widget or call to .icon() on our IconData class instances
///
/// Example:
/// FontIcon($fontFamily.our_icon);
/// or 
/// $fontFamily.our_icon.icon();


import 'dart:ui';
import 'package:flutter/widgets.dart';

class $fontFamily {
  $fontFamily._();

  static const _fontFamily = '$fontFamily';
  static const String? _fontPackage = ${fontPackage.isNotEmpty ? "'$fontPackage'" : null};

''';

  final icons = package.icons;

  for (int index = 0; index < icons.length; index++) {
    final e = icons[index];

    if (!e.selected) {
      continue;
    }

    dartFileAsString += ''' 
  static const IconData ${e.name} = IconData(0x${e.hexCode}, fontFamily: _fontFamily, fontPackage: _fontPackage);
''';
  }

  dartFileAsString += '''
}



extension IconDataExt on IconData {
  Widget icon({
    Key? key,
    double size = 24,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    List<Shadow>? shadows,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return FontIcon(
      this,
      key: key,
      size: size,
      fill: fill,
      weight: weight,
      color: color,
      grade: grade,
      opticalSize: opticalSize,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}

class FontIcon extends Icon {
  const FontIcon(
    super.icon, {
    super.key,
    super.size,
    super.fill,
    super.weight,
    super.grade,
    super.opticalSize,
    super.color,
    super.shadows,
    super.semanticLabel,
    super.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: RichText(
          overflow: TextOverflow.visible, // Never clip.
          textDirection: textDirection,
          text: TextSpan(
            text: String.fromCharCode(icon!.codePoint),
            style: TextStyle(
              fontVariations: <FontVariation>[
                if (fill != null) FontVariation('FILL', fill!),
                if (weight != null) FontVariation('wght', weight!),
                if (grade != null) FontVariation('GRAD', grade!),
                if (opticalSize != null) FontVariation('opsz', opticalSize!),
              ],
              inherit: false,
              color: color ?? IconTheme.of(context).color,
              fontSize: size,
              fontFamily: icon!.fontFamily,
              package: icon!.fontPackage,
              shadows: shadows,
            ),
          ),
        ),
      ),
    );
  }
}
''';

  return dartFileAsString;
}
