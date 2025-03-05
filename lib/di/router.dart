import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/popular_posts_repository.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/features/login/views/login_page_sns.dart';
import 'package:brew_buds/features/signup/views/signup_third_page.dart';
import 'package:brew_buds/features/signup/views/signup_first_page.dart';
import 'package:brew_buds/features/signup/views/signup_second_page.dart';
import 'package:brew_buds/features/signup/views/signup_finish_page.dart';
import 'package:brew_buds/features/signup/views/signup_fourth_page.dart';
import 'package:brew_buds/home/all/home_all_presenter.dart';
import 'package:brew_buds/home/home_screen.dart';
import 'package:brew_buds/home/popular_posts/popular_posts_presenter.dart';
import 'package:brew_buds/home/popular_posts/popular_posts_view.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/main/main_view.dart';
import 'package:brew_buds/photo/view/photo_grid_view.dart';
import 'package:brew_buds/profile/presenter/edit_profile_presenter.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/profile/view/edit_profile_view.dart';
import 'package:brew_buds/profile/view/my_profile_view.dart';
import 'package:brew_buds/search/search_home_presenter.dart';
import 'package:brew_buds/search/search_home_view.dart';
import 'package:brew_buds/search/search_result_presenter.dart';
import 'package:brew_buds/search/search_result_view.dart';
import 'package:brew_buds/setting/presenter/account_detail_presenter.dart';
import 'package:brew_buds/setting/presenter/blocking_user_management_presenter.dart';
import 'package:brew_buds/setting/view/account_detail_view.dart';
import 'package:brew_buds/setting/view/account_info_view.dart';
import 'package:brew_buds/setting/setting_screen.dart';
import 'package:brew_buds/setting/view/blocking_user_management_view.dart';
import 'package:brew_buds/setting/view/notification_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const String initialPath = '/login';

final GlobalKey<NestedScrollViewState> homeTabBarScrollState = GlobalKey<NestedScrollViewState>();
final GlobalKey<NavigatorState> mainRootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> homeRootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: mainRootNavigatorKey,
  initialLocation: initialPath,
  redirect: (context, state) {
    if (context.read<AccountRepository>().refreshToken.isNotEmpty) {
      if (state.uri.path.contains('login') || state.uri.path.contains('signup')) {
        return '/home';
      }
    } else {
      if (!state.uri.path.contains('login') && !state.uri.path.contains('signup')) {
        return '/login';
      }
    }

    return state.fullPath;
  },
  refreshListenable: AccountRepository.instance,
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
        return const SignUpFirstPage();
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
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: mainRootNavigatorKey,
      builder: (context, state, bottomNavigationShell) => MainView(navigationShell: bottomNavigationShell),
      branches: [
        StatefulShellBranch(
          //홈 화면
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => HomeAllPresenter(repository: HomeRepository.instance),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => HomePostPresenter(repository: HomeRepository.instance),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => HomeTastingRecordPresenter(repository: HomeRepository.instance),
                  ),
                ],
                child: HomeView(nestedScrollViewState: homeTabBarScrollState),
              ),
              routes: [
                GoRoute(
                  path: '/popular_post',
                  builder: (context, state) => ChangeNotifierProvider<PopularPostsPresenter>(
                    create: (_) => PopularPostsPresenter(repository: PopularPostsRepository.instance),
                    child: const PopularPostsView(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          //검색 화면
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => ChangeNotifierProvider<SearchHomePresenter>(
                create: (_) => SearchHomePresenter(currentTabIndex: 0, searchWord: ''),
                child: const SearchHomeView(),
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
                      child: SearchResultView(initialText: data?.searchWord ?? ''),
                    );
                  },
                ),
              ],
            ),
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
              builder: (context, state) => ChangeNotifierProvider<ProfilePresenter>(
                create: (_) => ProfilePresenter(repository: ProfileRepository.instance),
                child: const MyProfileView(),
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final EditProfileData data = state.extra as EditProfileData;
                    return ChangeNotifierProvider<EditProfilePresenter>(
                      create: (_) => EditProfilePresenter(
                        selectedCoffeeLifeList: data.coffeeLife,
                        imageUri: data.imageUri,
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
                    GoRoute(
                      path: 'block',
                      builder: (context, state) => ChangeNotifierProvider<BlockingUserManagementPresenter>(
                        create: (_) => BlockingUserManagementPresenter(),
                        child: const BlockingUserManagementView(),
                      ),
                    ),
                    GoRoute(path: 'account_info', builder: (context, state) => const AccountInfoView()),
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
    ),
  ],
);
