import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';

import '../../../../../domain/models/package.dart';
import '../../../../generated/translations.g.dart';
import '../../../../global/theme/colors.dart';
import '../../../../router/router.dart';

class PackagesViewer extends StatelessWidget {
  const PackagesViewer({super.key, required this.packages});
  final List<Package> packages;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = () {
      switch (context.mediaQuery.size.width) {
        case >= 1200:
          return 4;
        case >= 768:
          return 3;
        case _:
          return 2;
      }
    }();

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: 16 / 9,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(15),
      children: packages.map(
        (e) {
          final name = e.name;
          var letters = e.name[0];

          final words = name.split(' ');
          if (words.length > 1) {
            letters = words[0][0] + words[1][0];
          }

          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            elevation: 0,
            child: InkWell(
              onTap: () => PackageRoute(id: e.id).push(context),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: AppColors.darkLight,
                        child: Text(
                          letters,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(name),
                    Text(
                      texts.dashboard.packages.icons(
                        count: e.icons.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
