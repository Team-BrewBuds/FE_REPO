import 'package:animations/animations.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/home/home_presenter.dart';
import 'package:brew_buds/domain/home/home_screen.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_posts_presenter.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_posts_view.dart';
import 'package:brew_buds/domain/login/presenter/login_presenter.dart';
import 'package:brew_buds/domain/login/views/login_page_first.dart';
import 'package:brew_buds/domain/login/views/login_page_sns.dart';
import 'package:brew_buds/domain/main/main_view.dart';
import 'package:brew_buds/domain/profile/presenter/edit_profile_presenter.dart';
import 'package:brew_buds/domain/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/domain/profile/view/edit_profile_view.dart';
import 'package:brew_buds/domain/profile/view/my_profile_view.dart';
import 'package:brew_buds/domain/search/search_presenter.dart';
import 'package:brew_buds/domain/search/search_screen.dart';
import 'package:brew_buds/domain/setting/presenter/account_detail_presenter.dart';
import 'package:brew_buds/domain/setting/presenter/account_info_presenter.dart';
import 'package:brew_buds/domain/setting/presenter/blocking_user_management_presenter.dart';
import 'package:brew_buds/domain/setting/presenter/notification_setting_presenter.dart';
import 'package:brew_buds/domain/setting/setting_screen.dart';
import 'package:brew_buds/domain/setting/view/account_detail_view.dart';
import 'package:brew_buds/domain/setting/view/account_info_view.dart';
import 'package:brew_buds/domain/setting/view/blocking_user_management_view.dart';
import 'package:brew_buds/domain/setting/view/notification_setting_view.dart';
import 'package:brew_buds/domain/setting/view/sign_out_view.dart';
import 'package:brew_buds/domain/signup/sign_up_presenter.dart';
import 'package:brew_buds/domain/signup/signup_screen.dart';
import 'package:brew_buds/domain/signup/views/signup_finish_page.dart';
import 'package:brew_buds/domain/signup/views/signup_first_page.dart';
import 'package:brew_buds/domain/signup/views/signup_fourth_page.dart';
import 'package:brew_buds/domain/signup/views/signup_second_page.dart';
import 'package:brew_buds/domain/signup/views/signup_third_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/v4.dart';

GoRouter createRouter(bool hasToken) {
  return GoRouter(
    initialLocation: hasToken ? '/home' : '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPageFirst();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'login',
            builder: (BuildContext context, GoRouterState state) => ChangeNotifierProvider(
              create: (context) => LoginPresenter(),
              child: const SNSLogin(),
            ),
            routes: [
              StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) {
                  return ChangeNotifierProvider(
                    create: (_) => SignUpPresenter(),
                    child: SignupScreen(navigationShell: navigationShell),
                  );
                },
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'signup/1',
                        builder: (BuildContext context, GoRouterState state) {
                          return const SignUpFirstPage();
                        },
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'signup/2',
                        builder: (BuildContext context, GoRouterState state) {
                          return const SignUpSecondPage();
                        },
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'signup/3',
                        builder: (BuildContext context, GoRouterState state) {
                          return const SignUpThirdPage();
                        },
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'signup/4',
                        builder: (BuildContext context, GoRouterState state) {
                          return const SignUpFourthPage();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'signup/finish',
                builder: (BuildContext context, GoRouterState state) {
                  return SignupFinishPage(nickname: state.uri.queryParameters['nickname'] ?? 'Unknown');
                },
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        pageBuilder: (context, state, child) {
          final hideBottomBar = (state.fullPath?.split('/').length ?? 0) > 2;
          return CustomTransitionPage(
            child: ShowCaseWidget(
              onComplete: (_, __) {
                SharedPreferencesRepository.instance.completeTutorial();
              },
              builder: (context) => MainView(isHideBottomBar: hideBottomBar, child: child),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            name: const UuidV4().generate(),
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: ChangeNotifierProvider<HomePresenter>(
                create: (_) {
                  final isGuest = (state.uri.queryParameters['is_guest'] ?? 'false') == 'false' ? false : true;
                  return HomePresenter(isGuest: isGuest);
                },
                child: const HomeView(),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              name: const UuidV4().generate(),
            ),
            routes: [
              GoRoute(
                path: '/popular_post',
                builder: (context, state) => ChangeNotifierProvider<PopularPostsPresenter>(
                  create: (_) => PopularPostsPresenter(),
                  child: const PopularPostsView(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: ChangeNotifierProvider<SearchPresenter>(
                create: (_) => SearchPresenter(),
                child: const SearchScreen(),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            ),
            name: const UuidV4().generate(),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: ChangeNotifierProvider<ProfilePresenter>(
                create: (_) => ProfilePresenter(),
                child: const MyProfileView(),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              name: const UuidV4().generate(),
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final EditProfileData data = state.extra as EditProfileData;
                  return ChangeNotifierProvider<EditProfilePresenter>(
                    create: (_) => EditProfilePresenter(
                      selectedCoffeeLifeList: data.coffeeLife,
                      imageUrl: data.imageUrl,
                      nickname: data.nickname,
                      introduction: data.introduction,
                      link: data.link,
                    ),
                    child: EditProfileView(
                      nickname: data.nickname,
                      introduction: data.introduction,
                      link: data.link,
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'setting',
                builder: (context, state) => const SettingScreen(),
                routes: [
                  GoRoute(
                    path: 'notification',
                    builder: (context, state) => ChangeNotifierProvider(
                      create: (_) => NotificationSettingPresenter(),
                      child: const NotificationSettingView(),
                    ),
                  ),
                  GoRoute(path: 'sign_out', builder: (context, state) => const SignOutView()),
                  GoRoute(
                    path: 'block',
                    builder: (context, state) => ChangeNotifierProvider<BlockingUserManagementPresenter>(
                      create: (_) => BlockingUserManagementPresenter(),
                      child: const BlockingUserManagementView(),
                    ),
                  ),
                  GoRoute(
                    path: 'account_info',
                    builder: (context, state) => ChangeNotifierProvider<AccountInfoPresenter>(
                      create: (_) => AccountInfoPresenter(),
                      child: const AccountInfoView(),
                    ),
                  ),
                  GoRoute(
                    path: 'account_detail',
                    builder: (context, state) => ChangeNotifierProvider<AccountDetailPresenter>(
                      create: (_) => AccountDetailPresenter(),
                      child: const AccountDetailView(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
