import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/data/home/home_repository.dart';
import 'package:brew_buds/data/popular_posts/popular_posts_repository.dart';
import 'package:brew_buds/data/profile/profile_repository.dart';
import 'package:brew_buds/features/login/models/login_model.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/features/login/views/login_page_sns.dart';
import 'package:brew_buds/features/signup/views/signup_cert_page.dart';
import 'package:brew_buds/features/signup/views/signup_page.dart';
import 'package:brew_buds/features/signup/views/signup_page_enjoy.dart';
import 'package:brew_buds/features/signup/views/signup_page_finish.dart';
import 'package:brew_buds/features/signup/views/signup_select_page.dart';
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
import 'package:brew_buds/profile/presenter/alarm_presenter.dart';
import 'package:brew_buds/profile/profile_screen.dart';
import 'package:brew_buds/profile/views/account_out_view.dart';
import 'package:brew_buds/profile/views/alarm_view.dart';
import 'package:brew_buds/profile/views/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:brew_buds/profile/presenter/edit_presenter.dart';
import '../profile/views/account_info_view.dart';
import '../profile/views/block_view.dart';
import '../profile/views/edit_view.dart';
import '../profile/views/fitInfo_view.dart';

const String initialPath = '/login';

final GlobalKey<NestedScrollViewState> homeTabBarScrollState =
    GlobalKey<NestedScrollViewState>();

final router = GoRouter(
  initialLocation: initialPath,
  routes: [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPageFirst();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'sns',
          builder: (BuildContext context, GoRouterState state) {
            final authService = AuthService();
            final loginModel = LoginModel();
            final loginPresenter = LoginPresenter(loginModel, authService);
            return SNSLogin(presenter: loginPresenter);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return Signup();
      },
      routes: [
        GoRoute(
          path: 'enjoy',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpEnjoy();
          },
        ),
        GoRoute(
          path: 'cert',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpCert();
          },
        ),
        GoRoute(
          path: 'select',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpSelect();
          },
        ),
        GoRoute(
          path: 'finish',
          builder: (BuildContext context, GoRouterState state) {
            return SignupPageFinish();
          },
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, bottomNavigationShell) =>
          MainView(navigationShell: bottomNavigationShell),
      branches: [
        StatefulShellBranch(
          //홈 화면
          routes: [
            ShellRoute(
              builder: (context, state, child) => HomeView(
                  nestedScrollViewState: homeTabBarScrollState, child: child),
              routes: [
                GoRoute(
                  path: '/home/all',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionsBuilder: (context, primaryAnimation,
                          secondaryAnimation, Widget child) {
                        return FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child, // 자식 위젯
                        );
                      },
                      child: ChangeNotifierProvider<HomeAllPresenter>(
                        create: (_) => HomeAllPresenter(
                            repository: HomeRepository.instance),
                        child: HomeAllView(
                            scrollController: homeTabBarScrollState
                                .currentState?.innerController),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: '/home/tastingRecord',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionsBuilder: (context, primaryAnimation,
                          secondaryAnimation, Widget child) {
                        return FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child, // 자식 위젯
                        );
                      },
                      child: ChangeNotifierProvider<HomeTastingRecordPresenter>(
                        create: (_) => HomeTastingRecordPresenter(
                            repository: HomeRepository.instance),
                        child: HomeTastingRecordView(
                          scrollController: homeTabBarScrollState
                              .currentState?.innerController,
                        ),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: '/home/post',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionsBuilder: (context, primaryAnimation,
                          secondaryAnimation, Widget child) {
                        return FadeThroughTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        );
                      },
                      child: ChangeNotifierProvider<HomePostPresenter>(
                        create: (_) => HomePostPresenter(
                            repository: HomeRepository.instance),
                        child: HomePostView(
                          scrollController: homeTabBarScrollState
                              .currentState?.innerController,
                          jumpToTop: () => homeTabBarScrollState
                              .currentState?.outerController
                              .jumpTo(0),
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
            GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/popular_post',
      builder: (context, state) =>
          ChangeNotifierProvider<PopularPostsPresenter>(
        create: (_) =>
            PopularPostsPresenter(repository: PopularPostsRepository.instance),
        child: const PopularPostsView(),
      ),
    ),
    GoRoute(
        path: '/profile_setting',
        builder: (context, state) => const SettingView()),
    GoRoute(
        path: '/profile_edit',
        builder: (context, state) =>
            ChangeNotifierProvider<ProfileEditPresenter>(
                create: (_) =>
                    ProfileEditPresenter(repository: ProfileRepository()),
                child: const ProfileEditScreen())),
    GoRoute(
        path: '/profile_fitInfo',
        builder: (context, state) => const FitInfoView()),
    GoRoute(
        path: '/profile_accountInfo',
        builder: (context, state) => const ProfileAccountInfoView()),
    GoRoute(
        path: '/profile_block',
        builder: (context, state) =>
            ChangeNotifierProvider<ProfileEditPresenter>(
                create: (_) =>
                    ProfileEditPresenter(repository: ProfileRepository()),
                child: const BlockView())),
    GoRoute(
        path: '/account_out',
        builder: (context, state) => const AccountOutView()),
    GoRoute(
        path: '/alarm',
        builder: (context, state) => ChangeNotifierProvider(
            create: (_) {
              final presenter = AlarmPresenter();
              Future<bool> value = presenter.NotificationPermissionCheck(); // 초기화 중 권한 확인
              presenter.loadSetting(value);
              return presenter;
            },
            child: AlarmView())),
  ],
);
