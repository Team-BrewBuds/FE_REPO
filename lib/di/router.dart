import 'package:brew_buds/main/main_view.dart';
import 'package:brew_buds/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String initialPath = '/profile';

final router = GoRouter(
  initialLocation: initialPath,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, bottomNavigationShell) => MainView(navigationShell: bottomNavigationShell),
      branches: [
        StatefulShellBranch(//홈 화면
          routes: [
            GoRoute(path: '/main1', builder: (context, state) => Container()),
          ],
        ),
        StatefulShellBranch(//검색 화면
          routes: [
            GoRoute(path: '/main2', builder: (context, state) => Container()),
          ],
        ),
        StatefulShellBranch(//기록 화면
          routes: [
            GoRoute(path: '/main3', builder: (context, state) => Container()),
          ],
        ),
        StatefulShellBranch(//프로필 화면
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
          ],
        ),
      ],
    )
  ],
);
