import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/home/feed/feed_widget.dart';
import 'package:brew_buds/domain/home/feed/presenter/tasted_record_feed_presenter.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TastedRecordFeedWidget extends FeedWidget<TastedRecordFeedPresenter> {
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
        TastingRecordCard(
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
              const SizedBox(height: 8),
              ThrottleButton(
                onTap: () {
                  if (isGuest) {
                    onGuest.call();
                  } else {
                    final id = context.read<TastedRecordFeedPresenter>().feed.data.id;
                    showTastingRecordDetail(context: context, id: id);
                  }
                },
                child: Text(
                  '더보기',
                  style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.gray50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  onTappedCommentsButton(BuildContext context) {
    final id = context.read<TastedRecordFeedPresenter>().feed.data.id;
    final author = context.read<TastedRecordFeedPresenter>().feed.data.author;
    onTapComments.call(false, id, author);
  }

  @override
  onTappedProfile(BuildContext context) {
    final author = context.read<TastedRecordFeedPresenter>().feed.data.author;
    ScreenNavigator.pushToProfile(context: context, id: author.id);
  }
}
