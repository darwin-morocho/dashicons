import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:flutter_meedu/providers.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/theme/colors.dart';
import '../../bloc/package_bloc.dart';

class PackageSize extends ConsumerWidget {
  const PackageSize({super.key});

  @override
  Widget build(BuildContext context, BuilderRef ref) {
    final state = ref
        .watch(
          packageProvider.select(
            (bloc) => bloc.package.icons.length,
          ),
        )
        .state;
    final size = utf8
            .encode(jsonEncode(
              state.package.toJson(),
            ))
            .length /
        1024;

    final value = (size / 1000).clamp(0.0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AppColors.darkWhite.withOpacity(0.3),
            ),
          ),
        ),
        Text(
          texts.package.usedStorage(
            value: (value * 100).round(),
          ),
        ),
      ],
    ).paddingOnly(
      left: 20,
      right: 10,
    );
  }
}
