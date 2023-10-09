import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../../../../../../domain/models/font_cache.dart';
import '../../../../../../../../domain/use_cases/packages/get_cached_font.dart';
import '../../../../../../../dependency_injection.dart';
import '../../../../../../../global/widgets/loading.dart';
import '../../../bloc/package_bloc.dart';
import '../../../bloc/package_state.dart';
import '../../dialogs/icon_options.dart';
import '../drag_and_drop.dart';
import 'icon_tile.dart';

class IconsViewer extends StatefulWidget {
  const IconsViewer({super.key});

  @override
  State<IconsViewer> createState() => _IconsViewerState();
}

class _IconsViewerState extends State<IconsViewer> {
  final _scrollController = ScrollController();
  late PackageState _state = packageProvider.read().state;
  FontCache? _cache;
  String _fontFamily = '';
  late final _getCachedFontUseCase = GetCachedFontUseCase(
    Repositories.packages.read(),
  );

  @override
  void initState() {
    super.initState();
    _init();
    packageProvider.read().addListener(_listener);
  }

  void _listener(PackageState state) {
    _state = state;
    _init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    packageProvider.read().removeListener(_listener);
    super.dispose();
  }

  Future<void> _init() async {
    final package = _state.package;
    if (package.icons.isEmpty) {
      setState(() {
        _cache = FontCache(
          packageId: package.id,
          base64Ttf: '',
          lastId: package.lastId,
        );
      });
      return;
    }

    if (package.lastId == _cache?.lastId) {
      setState(() {});
      return;
    }

    setState(() {
      _cache = null;
    });

    final cache = await _getCachedFontUseCase(package);
    if (cache != null) {
      if (cache.base64Ttf.isNotEmpty) {
        _fontFamily = DateTime.now().millisecondsSinceEpoch.toString();
        final loader = FontLoader(_fontFamily);

        loader.addFont(
          Future.value(
            ByteData.view(base64.decode(cache.base64Ttf).buffer),
          ),
        );
        await loader.load();
        setState(() {
          _cache = cache;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cache == null) {
      return const Center(
        child: LoadingAnimation(),
      );
    }

    final icons = _state.package.icons;

    if (icons.isEmpty) {
      return const DragAndDrop();
    }

    return Column(
      children: [
        const SizedBox(height: 25),
        const SizedBox(
          height: 140,
          child: DragAndDrop(),
        ),
        Expanded(
          child: ReorderableGridView.builder(
            controller: _scrollController,
            onReorder: packageProvider.read().onReorder,
            padding: const EdgeInsets.symmetric(vertical: 30).copyWith(top: 20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 60,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: icons.length,
            itemBuilder: (_, index) {
              final item = icons[index];
              return IconTile(
                key: ValueKey(item.id),
                reorder: _state.reorder,
                icon: item,
                fontFamily: _fontFamily,
                onTap: () => packageProvider.read().onToggleSelection(item),
                onRightClick: (context) => showIconOptionsContextMenu(
                  context: context,
                  icon: item,
                  fontFamily: _fontFamily,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
