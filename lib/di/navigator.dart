import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/follow_list/follower_list_pa.dart';
import 'package:brew_buds/follow_list/follower_list_pb.dart';
import 'package:brew_buds/follow_list/follower_list_pb_presenter.dart';
import 'package:brew_buds/follow_list/follower_list_presenter.dart';
import 'package:brew_buds/profile/presenter/other_profile_presenter.dart';
import 'package:brew_buds/profile/presenter/tasted_report_presenter.dart';
import 'package:brew_buds/profile/view/other_profile_view.dart';
import 'package:brew_buds/profile/view/taste_report_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

pushToProfile({required BuildContext context, required int id}) {
  if (id == AccountRepository.instance.id) {
    context.go('/profile');
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<OtherProfilePresenter>(
          create: (_) => OtherProfilePresenter(id: id, repository: ProfileRepository.instance),
          child: const OtherProfileView(),
        ),
      ),
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
        create: (_) => FollowerListPresenter(id: id, nickName: nickName),
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

Future<T?> pushToTasteReport<T>({required BuildContext context}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider<TasteReportPresenter>(
        create: (_) => TasteReportPresenter(id: 1, nickname: '닉네임'),
        child: TasteReportView(),
      ),
    ),
  );
}
