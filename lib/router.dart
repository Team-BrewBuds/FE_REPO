import 'package:brew_buds/features/signup/views/signup_cert_page.dart';
import 'package:brew_buds/features/signup/views/signup_page.dart';
import 'package:brew_buds/features/signup/views/signup_page_enjoy.dart';
import 'package:brew_buds/features/signup/views/signup_page_finish.dart';
import 'package:brew_buds/features/signup/views/signup_select_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'core/auth_service.dart';
import 'features/login/models/login_model.dart';
import 'features/login/presenter/login_presenter.dart';
import 'features/login/views/login_page.dart';
import 'features/login/views/login_page_first.dart';
import 'features/login/views/login_page_sns.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPageFirst();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/login/sns',
          builder: (BuildContext context, GoRouterState state) {
            final authService = AuthService();
            final loginModel = LoginModel();
            final loginPresenter = LoginPresenter(loginModel, authService);
            return snsLogin(presenter: loginPresenter);
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return Signup();
          },
        ),
        GoRoute(
          path: 'signup/enjoy',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpEnjoy();
          },
        ),
        GoRoute(
          path: 'signup/cert',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpCert();
          },
        ),
        GoRoute(
          path: 'signup/select',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpSelect();
          },
        ),
        GoRoute(
          path: 'signup/finish',
          builder: (BuildContext context, GoRouterState state) {
            return SignupPageFinish();
          },
        ),
      ],
    ),
  ],
);
