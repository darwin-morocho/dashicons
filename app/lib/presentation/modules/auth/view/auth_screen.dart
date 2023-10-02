import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';

import '../../../global/widgets/main_scaffold/footer.dart';
import '../../../global/widgets/max_size.dart';
import '../submodules/sign_in/view/sign_in_view.dart';
import '../submodules/sign_up/view/sign_up_view.dart';
import 'widgets/page_view.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MaxSize(
                width: 1200,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (context.width >= 1000) ...[
                        const Expanded(
                          flex: 2,
                          child: AuthPageView(),
                        ),
                        const SizedBox(width: 30),
                      ],
                      const Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: TabBarView(
                            children: [
                              SignInView(),
                              SignUpView(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const MainFooter(),
          ],
        ),
      ),
    );
  }
}
