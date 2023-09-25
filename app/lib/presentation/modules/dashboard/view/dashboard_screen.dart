import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/assets.gen.dart';
import '../../../generated/translations.g.dart';
import '../../../global/widgets/loading.dart';
import '../../../global/widgets/max_size.dart';
import '../bloc/dashboard_bloc.dart';
import 'popups/new_package.dart';
import 'widgets/packages_viewer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return MaxSize(
      width: 1200,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: ref.watch(dashboardProvider).state.map(
              loading: (_) => const Center(
                child: LoadingAnimation(),
              ),
              failed: (_) => const Center(
                child: Text('Error'),
              ),
              loaded: (state) {
                if (state.packages.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaxSize(
                        width: 600,
                        height: 380,
                        child: SvgPicture.asset(
                          Assets.dashboard.noPackages,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => addOrUpdatePackage(context),
                        child: Text(texts.dashboard.createMyFirstIconsPackage),
                      ),
                    ],
                  );
                }

                return PackagesViewer(packages: state.packages);
              },
            ),
      ),
    );
  }
}
