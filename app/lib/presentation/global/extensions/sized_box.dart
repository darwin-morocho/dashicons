import 'package:flutter/widgets.dart';

extension SizedBoxDoubleExt on double {
  SizedBox get w => SizedBox(width: this);
  SizedBox get h => SizedBox(height: this);
}


extension SizedBoxIntExt on int {
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get h => SizedBox(height: toDouble());
}
