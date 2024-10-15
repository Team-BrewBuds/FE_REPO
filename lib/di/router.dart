import 'package:brew_buds/home/all/home_all_presenter.dart';
import 'package:brew_buds/home/all/home_all_view.dart';
import 'package:brew_buds/home/home_screen.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/post/home_post_view.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_view.dart';
import 'package:brew_buds/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const String initialPath = '/';

final router = GoRouter(
  initialLocation: initialPath,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, bottomNavigationShell) => MainView(navigationShell: bottomNavigationShell),
      branches: [
        StatefulShellBranch(//홈 화면
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (context, state, topNavigationShell) => HomeView(navigationShell: topNavigationShell),
              branches: [
                StatefulShellBranch(
                  //전체 피드
                  routes: [
                    GoRoute(
                      path: '/home/all',
                      builder: (context, state) => ChangeNotifierProvider<HomeAllPresenter>(
                        create: (_) => HomeAllPresenter(feeds: List<Feed>.from(dummyPosts)..addAll(dummyTastingRecord), remandedUsers: dummyUsers),
                        child: HomeAllView(),
                      ),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  //시음기록 피드
                  routes: [
                    GoRoute(
                      path: '/home/tastingRecord',
                      builder: (context, state) => ChangeNotifierProvider<HomeTastingRecordPresenter>(
                        create: (_) => HomeTastingRecordPresenter(tastingRecords: dummyTastingRecord, remandedUsers: dummyUsers),
                        child: HomeTastingRecordView(),
                      ),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  //게시글 피드
                  routes: [
                    GoRoute(
                      path: '/home/post',
                      builder: (context, state) => ChangeNotifierProvider<HomePostPresenter>(
                        create: (_) => HomePostPresenter(posts: dummyPosts, remandedUsers: dummyUsers),
                        child: HomePostView(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
            GoRoute(path: '/main4', builder: (context, state) => Container()),
          ],
        ),
      ],
    )
  ],
);
