import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/home/feed/feed_widget.dart';
import 'package:brew_buds/domain/home/feed/presenter/tasted_record_feed_presenter.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_card.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TastedRecordFeedWidget extends FeedWidget<TastedRecordFeedPresenter> {
  static Widget buildWithPresenter(
    TastedRecordFeedPresenter presenter, {
    required Future<void> Function() onGuest,
    required bool isGuest,
    required Future<void> Function(bool isPost, int id, User author) onTapComments,
  }) =>
      ChangeNotifierProvider.value(
        value: presenter,
        child: TastedRecordFeedWidget(
          isGuest: isGuest,
          onGuest: onGuest,
          onTapComments: onTapComments,
        ),
      );

  const TastedRecordFeedWidget({
    super.key,
    required super.isGuest,
    required super.onGuest,
    required super.onTapComments,
  });

  @override
  Widget buildBody(BuildContext context) {
    final state = context.select<TastedRecordFeedPresenter, BodyState>((presenter) => presenter.bodyState);
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThrottleButton(
          onTap: () {
            _pushToDetail(context);
          },
          child: TastingRecordCard(
            image: MyNetworkImage(
              imageUrl: state.image,
              height: width,
              width: width,
              showGradient: true,
            ),
            rating: state.rating,
            type: state.type,
            name: state.name,
            flavors: state.flavors,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.contents,
                style: TextStyles.bodyRegular,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Future<void> onTappedCommentsButton(BuildContext context) {
    final id = context.read<TastedRecordFeedPresenter>().feed.data.id;
    final author = context.read<TastedRecordFeedPresenter>().feed.data.author;
    return onTapComments.call(false, id, author);
  }

  @override
  Future<void> onTappedProfile(BuildContext context) {
    final author = context.read<TastedRecordFeedPresenter>().feed.data.author;
    return ScreenNavigator.showProfile(context: context, id: author.id);
  }

  _pushToDetail(BuildContext context) {
    if (isGuest) {
      onGuest.call();
    } else {
      final id = context.read<TastedRecordFeedPresenter>().feed.data.id;
      ScreenNavigator.showTastedRecordDetail(context: context, id: id);
    }
  }
}
