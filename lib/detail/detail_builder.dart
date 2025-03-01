import 'package:animations/animations.dart';
import 'package:brew_buds/detail/post_detail_presenter.dart';
import 'package:brew_buds/detail/post_detail_view.dart';
import 'package:brew_buds/detail/tasted_record_detail_view.dart';
import 'package:brew_buds/detail/tasted_record_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildOpenablePostDetailView({
  required int id,
  required Widget Function(BuildContext context, VoidCallback action) closeBuilder,
}) {
  return OpenContainer(
    transitionDuration: const Duration(milliseconds: 300),
    openBuilder: (context, action) => ChangeNotifierProvider<PostDetailPresenter>(
      create: (_) => PostDetailPresenter(id: id),
      child: const PostDetailView(),
    ),
    closedBuilder: closeBuilder,
  );
}

Widget buildOpenableTastingRecordDetailView({
  required int id,
  required Widget Function(BuildContext context, VoidCallback action) closeBuilder,
}) {
  return OpenContainer(
    transitionDuration: const Duration(milliseconds: 300),
    openBuilder: (context, action) => ChangeNotifierProvider<TastedRecordPresenter>(
      create: (_) => TastedRecordPresenter(id: id),
      child: const TastedRecordDetailView(),
    ),
    closedBuilder: closeBuilder,
  );
}
