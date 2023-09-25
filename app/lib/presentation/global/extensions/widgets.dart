import 'package:flutter/widgets.dart';

extension WidgetsExtension on Widget {
  SliverToBoxAdapter get toSliver {
    return SliverToBoxAdapter(child: this);
  }

  Padding padding(EdgeInsets padding) => Padding(padding: padding, child: this);
  Padding paddingAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  Padding paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        ),
        child: this,
      );

  SizedBox get fullWidth => SizedBox(width: double.infinity, child: this);

  Expanded get expanded => Expanded(child: this);

  Center get center => Center(child: this);
}
