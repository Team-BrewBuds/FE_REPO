import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/domain/detail/coffee_bean/coffee_bean_detail_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/coffee_bean_detail_screen.dart';
import 'package:brew_buds/domain/detail/post/post_detail_presenter.dart';
import 'package:brew_buds/domain/detail/post/post_detail_view.dart';
import 'package:brew_buds/domain/detail/tasted_record/tasted_record_detail_view.dart';
import 'package:brew_buds/domain/detail/tasted_record/tasted_record_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

Future<T?> showPostDetail<T>({required BuildContext context, required int id}) {
  return showCupertinoModalPopup<T>(
    barrierColor: ColorStyles.white,
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ChangeNotifierProvider<PostDetailPresenter>(
        create: (_) => PostDetailPresenter(id: id),
        child: const PostDetailView(),
      );
    },
  );
}

Future<T?> showTastingRecordDetail<T>({required BuildContext context, required int id}) {
  return showCupertinoModalPopup<T>(
    barrierColor: ColorStyles.white,
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ChangeNotifierProvider<TastedRecordPresenter>(
        create: (_) => TastedRecordPresenter(id: id),
        child: const TastedRecordDetailView(),
      );
    },
  );
}

Future<T?> showCoffeeBeanDetail<T>({required BuildContext context, required int id}) {
  return showCupertinoModalPopup<T>(
    barrierColor: ColorStyles.white,
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ChangeNotifierProvider<CoffeeBeanDetailPresenter>(
        create: (_) => CoffeeBeanDetailPresenter(id: id),
        child: const CoffeeBeanDetailScreen(),
      );
    },
  );
}
