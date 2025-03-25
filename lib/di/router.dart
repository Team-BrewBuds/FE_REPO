import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/domain/home/all/home_all_presenter.dart';
import 'package:brew_buds/domain/home/home_screen.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_posts_presenter.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_posts_view.dart';
import 'package:brew_buds/domain/home/post/home_post_presenter.dart';
import 'package:brew_buds/domain/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/domain/login/views/login_page_first.dart';
import 'package:brew_buds/domain/login/views/login_page_sns.dart';
import 'package:brew_buds/domain/main/main_view.dart';
import 'package:brew_buds/domain/profile/presenter/edit_profile_presenter.dart';
import 'package:brew_buds/domain/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/domain/profile/view/edit_profile_view.dart';
import 'package:brew_buds/domain/profile/view/my_profile_view.dart';
import 'package:brew_buds/domain/search/search_home_presenter.dart';
import 'package:brew_buds/domain/search/search_home_view.dart';
import 'package:brew_buds/domain/search/search_result_presenter.dart';
import 'package:brew_buds/domain/search/search_result_view.dart';
import 'package:brew_buds/domain/setting/presenter/account_detail_presenter.dart';
import 'package:brew_buds/domain/setting/presenter/account_info_presenter.dart';
import 'package:brew_buds/domain/setting/presenter/blocking_user_management_presenter.dart';
import 'package:brew_buds/domain/setting/setting_screen.dart';
import 'package:brew_buds/domain/setting/view/account_detail_view.dart';
import 'package:brew_buds/domain/setting/view/account_info_view.dart';
import 'package:brew_buds/domain/setting/view/blocking_user_management_view.dart';
import 'package:brew_buds/domain/setting/view/notification_setting_view.dart';
import 'package:brew_buds/domain/setting/view/sign_out_view.dart';
import 'package:brew_buds/domain/signup/views/signup_finish_page.dart';
import 'package:brew_buds/domain/signup/views/signup_first_page.dart';
import 'package:brew_buds/domain/signup/views/signup_fourth_page.dart';
import 'package:brew_buds/domain/signup/views/signup_second_page.dart';
import 'package:brew_buds/domain/signup/views/signup_third_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(bool hasToken) {
  final GlobalKey<NestedScrollViewState> homeTabBarScrollState = GlobalKey<NestedScrollViewState>();
  return GoRouter(
    initialLocation: hasToken ? '/home' : '/login',
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
              return const SNSLogin();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return SignUpFirstPage(
            accessToken: state.uri.queryParameters['access_token'] ?? '',
            refreshToken: state.uri.queryParameters['refresh_token'] ?? '',
            id: int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 0,
          );
        },
        routes: [
          GoRoute(
            path: 'second',
            builder: (BuildContext context, GoRouterState state) {
              return const SignUpSecondPage();
            },
          ),
          GoRoute(
            path: 'third',
            builder: (BuildContext context, GoRouterState state) {
              return const SignUpThirdPage();
            },
          ),
          GoRoute(
            path: 'fourth',
            builder: (BuildContext context, GoRouterState state) {
              return const SignUpFourthPage();
            },
          ),
          GoRoute(
            path: 'finish',
            builder: (BuildContext context, GoRouterState state) {
              return const SignupFinishPage();
            },
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => MainView(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => HomeAllPresenter(),
                ),
                ChangeNotifierProvider(
                  create: (_) => HomePostPresenter(),
                ),
                ChangeNotifierProvider(
                  create: (_) => HomeTastingRecordPresenter(),
                ),
              ],
              child: HomeView(
                key: (state.extra as UniqueKey?) ?? UniqueKey(),
                nestedScrollViewState: homeTabBarScrollState,
              ),
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
            builder: (context, state) => ChangeNotifierProvider<SearchHomePresenter>(
              create: (_) => SearchHomePresenter(currentTabIndex: 0, searchWord: ''),
              child: SearchHomeView(key: (state.extra as UniqueKey?) ?? UniqueKey(),),
            ),
            routes: [
              GoRoute(
                path: 'result',
                builder: (context, state) {
                  final data = state.extra as SearchResultInitState?;
                  return ChangeNotifierProvider<SearchResultPresenter>(
                    create: (_) => SearchResultPresenter(
                      currentTabIndex: data?.tabIndex ?? 0,
                      searchWord: data?.searchWord ?? '',
                    ),
                    child: SearchResultView(currentTabIndex: data?.tabIndex ?? 0, initialText: data?.searchWord ?? ''),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ChangeNotifierProvider<ProfilePresenter>(
              create: (_) => ProfilePresenter(repository: ProfileRepository.instance),
              child: MyProfileView(key: (state.extra as UniqueKey?) ?? UniqueKey(),),
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
                  GoRoute(path: 'notification', builder: (context, state) => const NotificationSettingView()),
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
