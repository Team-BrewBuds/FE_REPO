import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/domain/coffee_note_post/post_update_presenter.dart';
import 'package:brew_buds/domain/coffee_note_post/post_update_screen.dart';
import 'package:brew_buds/domain/coffee_note_post/post_write_presenter.dart';
import 'package:brew_buds/domain/coffee_note_post/post_write_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_first_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_navigator.dart';
import 'package:brew_buds/domain/follow_list/follower_list_pa.dart';
import 'package:brew_buds/domain/follow_list/follower_list_pb.dart';
import 'package:brew_buds/domain/follow_list/follower_list_pb_presenter.dart';
import 'package:brew_buds/domain/follow_list/follower_list_presenter.dart';
import 'package:brew_buds/domain/profile/presenter/other_profile_presenter.dart';
import 'package:brew_buds/domain/profile/presenter/tasted_report_presenter.dart';
import 'package:brew_buds/domain/profile/view/other_profile_view.dart';
import 'package:brew_buds/domain/profile/view/taste_report_view.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final class ScreenNavigator {
  static Future<void> pushToProfile({required BuildContext context, required int id}) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => ChangeNotifierProvider<OtherProfilePresenter>(
          create: (_) => OtherProfilePresenter(id: id),
          child: const OtherProfileView(),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  static Future<void> pushToFollowListPA({
    required BuildContext context,
    required int id,
    required String nickName,
    int initialIndex = 0,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        pageBuilder: (context, animation, secondaryAnimation) => ChangeNotifierProvider<FollowerListPresenter>(
          create: (_) => FollowerListPresenter(nickName: nickName),
          child: FollowerListPA(initialIndex: initialIndex),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static Future<void> pushToFollowListPB<T>({
    required BuildContext context,
    required int id,
    required String nickName,
    int initialIndex = 0,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        pageBuilder: (context, animation, secondaryAnimation) => ChangeNotifierProvider<FollowerListPBPresenter>(
          create: (_) => FollowerListPBPresenter(id: id, nickName: nickName),
          child: FollowerListPB(initialIndex: initialIndex),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static Future<void> pushToTasteReport<T>({required BuildContext context, required String nickname, required int id}) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        pageBuilder: (context, animation, secondaryAnimation) => ChangeNotifierProvider<TasteReportPresenter>(
          create: (_) => TasteReportPresenter(id: id, nickname: nickname),
          child: const TasteReportView(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  //수정필요
  static Future<bool?> showPostUpdateScreen({required BuildContext context, required Post post}) {
    return showCupertinoModalPopup<bool>(
      barrierColor: ColorStyles.white,
      barrierDismissible: false,
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => PostUpdatePresenter(post: post),
        child: PostUpdateScreen(title: post.title, content: post.contents, tag: post.tag.replaceAll(',', '#')),
      ),
    );
  }

  static Future<void> showTastedRecordWriteScreen(BuildContext context) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => const TastedRecordWriteNavigator(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static Future<void> showTastedRecordUpdateScreen({
    required BuildContext context,
    required TastedRecord tastedRecord,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => _buildTastingWriteScreen(context, tastedRecord),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static Widget _buildTastingWriteScreen(BuildContext context, TastedRecord tastedRecord) {
    return ChangeNotifierProvider(
      create: (context) => TastedRecordUpdatePresenter(tastedRecord: tastedRecord),
      child: Navigator(
        onGenerateInitialRoutes: (_, __) => [
          MaterialPageRoute(
            builder: (context) => const TastedRecordUpdateFirstScreen(),
          ),
        ],
      ),
    );
  }

  static Future<void> showPostWriteScreen({required BuildContext context}) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => ChangeNotifierProvider(
          create: (context) => PostWritePresenter(),
          child: const PostWriteScreen(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    return showCupertinoModalPopup<bool>(
      barrierColor: ColorStyles.white,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => PostWritePresenter(),
          child: const PostWriteScreen(),
        );
      },
    );
  }
}
