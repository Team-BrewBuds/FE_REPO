import 'package:brew_buds/data/home/home_repository.dart';
import 'package:brew_buds/data/popular_posts/popular_posts_repository.dart';
import 'package:brew_buds/home/all/home_all_presenter.dart';
import 'package:brew_buds/home/all/home_all_view.dart';
import 'package:brew_buds/home/home_screen.dart';
import 'package:brew_buds/home/popular_posts/popular_posts_presenter.dart';
import 'package:brew_buds/home/popular_posts/popular_posts_view.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/post/home_post_view.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_view.dart';
import 'package:brew_buds/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const String initialPath = '/home/all';

final GlobalKey<NestedScrollViewState> homeTabBarScrollState = GlobalKey<NestedScrollViewState>();

final router = GoRouter(
  initialLocation: initialPath,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, bottomNavigationShell) => MainView(navigationShell: bottomNavigationShell),
      branches: [
        StatefulShellBranch(
          //홈 화면
          routes: [
            ShellRoute(
              builder: (context, state, child) => HomeView(nestedScrollViewState: homeTabBarScrollState, child: child),
              routes: [
                GoRoute(
                  path: '/home/all',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionsBuilder: (context, primaryAnimation, secondaryAnimation, Widget child) {
                        return FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child, // 자식 위젯
                        );
                      },
                      child: ChangeNotifierProvider<HomeAllPresenter>(
                        create: (_) => HomeAllPresenter(repository: HomeRepository.instance),
                        child: HomeAllView(scrollController: homeTabBarScrollState.currentState?.innerController),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: '/home/tastingRecord',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionsBuilder: (context, primaryAnimation, secondaryAnimation, Widget child) {
                        return FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child, // 자식 위젯
                        );
                      },
                      child: ChangeNotifierProvider<HomeTastingRecordPresenter>(
                        create: (_) => HomeTastingRecordPresenter(repository: HomeRepository.instance),
                        child: HomeTastingRecordView(
                          scrollController: homeTabBarScrollState.currentState?.innerController,
                        ),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: '/home/post',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionsBuilder: (context, primaryAnimation, secondaryAnimation, Widget child) {
                        return FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        );
                      },
                      child: ChangeNotifierProvider<HomePostPresenter>(
                        create: (_) => HomePostPresenter(repository: HomeRepository.instance),
                        child: HomePostView(
                          scrollController: homeTabBarScrollState.currentState?.innerController,
                          jumpToTop: () => homeTabBarScrollState.currentState?.outerController.jumpTo(0),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          //검색 화면
          routes: [
            GoRoute(path: '/main2', builder: (context, state) => Container()),
          ],
        ),
        StatefulShellBranch(
          //기록 화면
          routes: [
            GoRoute(path: '/main3', builder: (context, state) => Container()),
          ],
        ),
        StatefulShellBranch(
          //프로필 화면
          routes: [
            GoRoute(path: '/main4', builder: (context, state) => Container()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/popular_post',
      builder: (context, state) => ChangeNotifierProvider<PopularPostsPresenter>(
        create: (_) => PopularPostsPresenter(repository: PopularPostsRepository.instance),
        child: PopularPostsView(),
      ),
    ),
  ],
);
