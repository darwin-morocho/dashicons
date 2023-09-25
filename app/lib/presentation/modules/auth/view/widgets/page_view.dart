import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../generated/assets.gen.dart';
import '../../../../generated/translations.g.dart';
import '../../../../global/extensions/build_context.dart';
import '../../../../global/extensions/duration.dart';
import '../../../../global/extensions/widgets.dart';
import '../../../../global/widgets/max_size.dart';

class AuthPageView extends HookWidget {
  const AuthPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();
    final items = useMemoized(
      () => [
        (Assets.signIn.dataPoints, texts.signIn.pageView.item1),
        (Assets.signIn.cloudSync, texts.signIn.pageView.item2),
        (Assets.signIn.tasting, texts.signIn.pageView.item3),
        (Assets.signIn.programmer, texts.signIn.pageView.item4),
      ],
    );
    final dragging = useRef(false);

    useEffect(
      () {
        final timer = Timer.periodic(
          5.seg,
          (timer) {
            if (dragging.value) {
              return;
            }
            var page = controller.page!.toInt() + 1;
            page = page < items.length ? page : 0;
            controller.animateToPage(
              page,
              duration: 300.ms,
              curve: Curves.linear,
            );
          },
        );
        return timer.cancel;
      },
      [],
    );

    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          GestureDetector(
            onHorizontalDragStart: (_) => dragging.value = true,
            onHorizontalDragUpdate: (_) => dragging.value = true,
            onHorizontalDragEnd: (_) => dragging.value = false,
            child: PageView.builder(
              controller: controller,
              itemBuilder: (_, index) {
                final tuple = items[index];
                return Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaxSize(
                        width: 800,
                        height: 380,
                        child: SvgPicture.asset(tuple.$1),
                      ),
                      const SizedBox(height: 20),
                      Markdown(
                        data: tuple.$2,
                        shrinkWrap: true,
                        styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.center,
                          p: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          strong: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: items.length,
            ),
          ).expanded,
          SmoothPageIndicator(
            controller: controller,
            count: items.length,
            effect: const WormEffect(),
            onDotClicked: (index) => controller.animateToPage(
              index,
              duration: 300.ms,
              curve: Curves.linear,
            ),
          ),
        ],
      ),
    );
  }
}
