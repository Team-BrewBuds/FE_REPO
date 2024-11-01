import 'package:brew_buds/common/text_button_factory.dart';
import 'package:brew_buds/common/text_styles.dart';
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
  final void Function() onTapMoreButton;

  const TastingRecordFeed({
    super.key,
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
    required this.onTapMoreButton,
  });

  @override
  FeedWidgetState createState() => _TastingRecordFeedState();
}

class _TastingRecordFeedState extends FeedWidgetState<TastingRecordFeed> {
  @override
  Widget buildBody() {
    final isOverFlow = _calcOverFlow(context);
    return Column(
      children: [
        TastingRecordCard(
          image: Image.network(
            widget.thumbnailUri,
            fit: BoxFit.cover,
            errorBuilder: (context, _, trace) => const Center(
              child: Text('No Image'),
            ),
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
                style: TextStyles.labelMediumRegular,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isOverFlow ? 8 : 0),
              isOverFlow
                  ? TextButtonFactory.build(
                      onTapped: widget.onTapMoreButton,
                      style: TextButtonStyle(size: TextButtonSize.small),
                      text: '더보기',
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  bool _calcOverFlow(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final TextPainter bodyTextPainter = TextPainter(
      text: TextSpan(text: widget.body, style: TextStyles.labelMediumRegular),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);

    return bodyTextPainter.didExceedMaxLines;
  }
}
