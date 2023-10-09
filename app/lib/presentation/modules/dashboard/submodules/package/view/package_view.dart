import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_meedu/consumer.dart';
import 'package:flutter_meedu/providers.dart';

import '../../../../../global/widgets/max_size.dart';
import '../bloc/package_bloc.dart';
import 'widgets/buttons.dart';
import 'widgets/code.dart';
import 'widgets/icons/icons.dart';
import 'widgets/segmented_controls.dart';

class PackageScreen extends HookWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxSize(
      width: 1200,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const PackageButtons(),
          const SizedBox(height: 20),
          const PackageSegmentedControls(),
          Expanded(
            child: Consumer(
              builder: (_, ref, __) {
                final index = ref.select(
                  packageProvider.select((bloc) => bloc.tabIndex),
                );
                return IndexedStack(
                  index: index,
                  children: const [
                    IconsViewer(),
                    CodeViewer(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
