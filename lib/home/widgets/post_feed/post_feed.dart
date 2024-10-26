import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_button_factory.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/widgets/feed_widget.dart';
import 'package:flutter/material.dart';

class PostFeed extends FeedWidget {
  final String title;
  final String body;
  final String tagText;
  final Widget tagIcon;
  final Widget? child;
  final void Function() onTapMoreButton;

  @override
  FeedWidgetState createState() => _PostFeedState();

  const PostFeed({
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
    required this.title,
    required this.body,
    required this.tagText,
    required this.tagIcon,
    this.child,
    required this.onTapMoreButton,
  });
}

class _PostFeedState extends FeedWidgetState<PostFeed> {
  late final int itemLength = 5;
  int currentIndex = 0;

  bool get isVisibleIndicator => itemLength > 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildBody() {
    if (widget.child != null) {
      return Column(
        children: [
          widget.child!,
          _buildTextBody(bodyMaxLines: 2),
        ],
      );
    } else {
      return _buildTextBody();
    }
  }

  Widget _buildTextBody({int bodyMaxLines = 5}) {
    final isOverFlow = _calcOverFlow(bodyMaxLines);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [_buildTag(), const Spacer()],
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            widget.title,
            style: TextStyles.titleMediumSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            widget.body,
            style: TextStyles.labelMediumRegular,
            maxLines: bodyMaxLines,
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
    );
  }

  Widget _buildTag() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black),
      child: Row(
        children: [
          SizedBox(height: 12, width: 12, child: widget.tagIcon),
          const SizedBox(width: 2),
          Text(widget.tagText, style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white)),
        ],
      ),
    );
  }

  bool _calcOverFlow(int maxLines) {
    final width = MediaQuery.of(context).size.width;
    final TextPainter bodyTextPainter = TextPainter(
      text: TextSpan(text: widget.body, style: TextStyles.labelMediumRegular),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);

    return bodyTextPainter.didExceedMaxLines;
  }
}
