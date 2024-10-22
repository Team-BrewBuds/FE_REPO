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
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const String initialPath = '/';
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
                          // FadeThroughTransition 애니메이션
                          animation: primaryAnimation, // 주 애니메이션
                          secondaryAnimation: secondaryAnimation, // 보조 애니메이션
                          child: child, // 자식 위젯
                        );
                      },
                      child: ChangeNotifierProvider<HomeAllPresenter>(
                        create: (_) => HomeAllPresenter(
                          feeds: List<Feed>.from(dummyPosts)..addAll(dummyTastingRecord),
                          remandedUsers: dummyUsers,
                        ),
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
                        print('build');
                        return FadeThroughTransition(
                          // FadeThroughTransition 애니메이션
                          animation: primaryAnimation, // 주 애니메이션
                          secondaryAnimation: secondaryAnimation, // 보조 애니메이션
                          child: child, // 자식 위젯
                        );
                      },
                      child: ChangeNotifierProvider<HomeTastingRecordPresenter>(
                        create: (_) => HomeTastingRecordPresenter(
                          tastingRecords: dummyTastingRecord,
                          remandedUsers: dummyUsers,
                        ),
                        child: HomeTastingRecordView(
                            scrollController: homeTabBarScrollState.currentState?.innerController),
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
                          // FadeThroughTransition 애니메이션
                          animation: primaryAnimation, // 주 애니메이션
                          secondaryAnimation: secondaryAnimation, // 보조 애니메이션
                          child: child, // 자식 위젯
                        );
                      },
                      child: ChangeNotifierProvider<HomePostPresenter>(
                        create: (_) {
                          print('build');
                          return HomePostPresenter(
                            posts: dummyPosts,
                            remandedUsers: dummyUsers,
                          );
                        },
                        child: HomePostView(scrollController: homeTabBarScrollState.currentState?.innerController),
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
        create: (_) => PopularPostsPresenter(popularPosts: List<Post>.from(dummyPosts)),
        child: PopularPostsView(),
      ),
    ),
  ],
);
