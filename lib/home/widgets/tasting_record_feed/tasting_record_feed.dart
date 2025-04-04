import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/detail/detail_builder.dart';
import 'package:brew_buds/home/widgets/feed_widget.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_card.dart';
import 'package:flutter/material.dart';

class TastingRecordFeed extends FeedWidget {
  final String thumbnailUri;
  final String rating;
  final String type;
  final String name;
  final List<String> tags;
  final String body;

  const TastingRecordFeed({
    super.key,
    required super.id,
    required super.writerThumbnailUri,
    required super.writerNickName,
    required super.writingTime,
    required super.hits,
    required super.isFollowed,
    required super.onTapProfile,
    required super.onTapFollowButton,
    required super.isLiked,
    required super.likeCount,
    required super.isLeaveComment,
    required super.commentsCount,
    required super.isSaved,
    required super.onTapLikeButton,
    required super.onTapCommentsButton,
    required super.onTapSaveButton,
    required this.thumbnailUri,
    required this.rating,
    required this.type,
    required this.name,
    required this.tags,
    required this.body,
  });

  @override
  FeedWidgetState createState() => _TastingRecordFeedState();
}

class _TastingRecordFeedState extends FeedWidgetState<TastingRecordFeed> {
  @override
  Widget buildBody() {
    final width = MediaQuery.of(context).size.width;
    final isOverFlow = _calcOverFlow(context);
    return Column(
      children: [
        TastingRecordCard(
          image: MyNetworkImage(
            imageUri: widget.thumbnailUri,
            height: width,
            width: width,
            color: const Color(0xffD9D9D9),
          ),
          rating: widget.rating,
          type: widget.type,
          name: widget.name,
          tags: widget.tags,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.body,
                style: TextStyles.bodyRegular,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isOverFlow ? 8 : 0),
              if (isOverFlow)
                buildOpenableTastingRecordDetailView(
                  id: widget.id,
                  closeBuilder: (context, action) => Text(
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

  bool _calcOverFlow(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final TextPainter bodyTextPainter = TextPainter(
      text: TextSpan(text: widget.body, style: TextStyles.bodyRegular),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);

    return bodyTextPainter.didExceedMaxLines;
  }
}
