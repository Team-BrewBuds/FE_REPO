import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/domain/coffee_note_post/post_update_presenter.dart';
import 'package:brew_buds/domain/coffee_note_post/post_update_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_first_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_presenter.dart';
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
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<String?> pushToProfile({required BuildContext context, required int id}) {
  if (id == AccountRepository.instance.id) {
    while (context.canPop()) {
      context.pop();
    }
    return context.push<String>('/profile');
  } else {
    return showCupertinoModalPopup<String?>(
      barrierColor: ColorStyles.white,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ChangeNotifierProvider<OtherProfilePresenter>(
          create: (_) => OtherProfilePresenter(id: id, repository: ProfileRepository.instance),
          child: const OtherProfileView(),
        );
      },
    );
  }
}

Future<T?> pushToFollowListPA<T>({
  required BuildContext context,
  required int id,
  required String nickName,
  int initialIndex = 0,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider<FollowerListPresenter>(
        create: (_) => FollowerListPresenter(nickName: nickName),
        child: FollowerListPA(initialIndex: initialIndex),
      ),
    ),
  );
}

Future<T?> pushToFollowListPB<T>({
  required BuildContext context,
  required int id,
  required String nickName,
  int initialIndex = 0,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider<FollowerListPBPresenter>(
        create: (_) => FollowerListPBPresenter(id: id, nickName: nickName),
        child: FollowerListPB(initialIndex: initialIndex),
      ),
    ),
  );
}

Future<T?> pushToTasteReport<T>({required BuildContext context, required String nickname, required int id}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider<TasteReportPresenter>(
        create: (_) => TasteReportPresenter(id: id, nickname: nickname),
        child: const TasteReportView(),
      ),
    ),
  );
}

Future<bool?> showPostUpdateScreen({required BuildContext context, required Post post}) {
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
