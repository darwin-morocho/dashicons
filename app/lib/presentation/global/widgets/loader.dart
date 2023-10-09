import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx.dart';

import 'loading.dart';

class Loader extends StatefulWidget {
  const Loader({super.key, this.child});
  final Widget? child;

  @override
  State<Loader> createState() => _LoaderState();

  static Future<T> show<T>(BuildContext context, Future<T> future) async {
    final state = context.findAncestorStateOfType<_LoaderState>();
    assert(state != null);
    state!.show();
    final result = await future;
    state.dismiss();

    return result;
  }
}

class _LoaderState extends State<Loader> {
  final loading = false.obs;

  void show() => loading.value = true;
  void dismiss() => loading.value = false;

  @override
  void dispose() {
    loading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: widget.child ?? const SizedBox.shrink(),
        ),
        RxBuilder(
          (_) => loading.value
              ? Positioned.fill(
                  child: Container(
                    color: Colors.white24,
                    child: const Center(
                      child: LoadingAnimation(),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
